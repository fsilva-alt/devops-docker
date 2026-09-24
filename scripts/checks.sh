#!/usr/bin/env bash
# Verificações de cada desafio. Carregado por check.sh.
# Cada função verificar_NN roda dentro da pasta do desafio (quando ele tem uma)
# e registra falhas com falhar "o que está errado" "dica". A missão extra usa
# extra_ok / extra_nao.

FALHAS=()
EXTRA=""

falhar()    { FALHAS+=("$1"$'\n'"   💡 $2"); }
extra_ok()  { EXTRA="ok"; }
extra_nao() { EXTRA="nao"; }

# --- predicados auxiliares ---------------------------------------------------

exigir_container_rodando() {   # nome, dica-de-run
  if ! container_existe "$1"; then
    falhar "Não existe um container chamado '$1'." "$2"
    return 1
  fi
  if ! container_rodando "$1"; then
    falhar "O container '$1' existe, mas não está rodando ($(docker container inspect -f '{{.State.Status}}' "$1"))." \
      "Veja o motivo com docker logs $1. Se ele saiu com erro, remova com docker rm $1 e rode de novo: $2"
    return 1
  fi
}

exigir_imagem_do_container() {   # container, imagem
  local img; img="$(container_imagem "$1")"
  [[ "$img" == "$2" ]] || falhar "O container '$1' foi criado a partir de '$img', não de '$2'." \
    "Remova com docker rm -f $1 e rode de novo usando a imagem $2."
}

exigir_porta() {   # container, porta-container, porta-host, url-de-teste, trecho-esperado, [dica se a resposta vier sem o trecho]
  local host; host="$(porta_publicada "$1" "$2")"
  if [[ -z "$host" ]]; then
    falhar "O container '$1' não publica a porta $2." "Remova-o (docker rm -f $1) e rode de novo com -p $3:$2"
    return 1
  fi
  if [[ "$host" != "$3" ]]; then
    falhar "A porta $2 do container está ligada à porta $host do Codespace, mas o desafio pede a $3." \
      "docker rm -f $1 e rode de novo com -p $3:$2"
    return 1
  fi
  local corpo; corpo="$(http_get "$4")"
  if [[ -z "$corpo" ]]; then
    falhar "A porta está publicada, mas $4 não respondeu." \
      "Veja docker logs $1: o programa dentro do container subiu? Ele escuta em 0.0.0.0?"
    return 1
  fi
  if [[ "$corpo" != *"$5"* ]]; then
    falhar "$4 respondeu, mas sem '$5' na resposta." "${6:-Confira o conteúdo com curl $4}"
    return 1
  fi
}

exigir_dockerfile() {
  [[ -f Dockerfile ]] || { falhar "Não há um arquivo chamado Dockerfile nesta pasta." "Crie o arquivo Dockerfile (com D maiúsculo, sem extensão) e escreva as instruções nele."; return 1; }
}

# linha_da INSTRUÇÃO [trecho]  -> número da primeira linha do Dockerfile que começa
# com a instrução (e contém o trecho); vazio se não há. Nunca falha (set -e).
linha_da() {
  local linhas
  linhas="$(grep -inE "^[[:space:]]*$1[[:space:]]" Dockerfile 2>/dev/null || true)"
  if [[ -n "${2:-}" ]]; then linhas="$(grep -i -- "$2" <<<"$linhas" || true)"; fi
  head -1 <<<"$linhas" | cut -d: -f1
}

# arquivo_compose -> imprime o nome do arquivo do Compose presente na pasta (vazio se nenhum)
arquivo_compose() {
  local f
  for f in compose.yaml compose.yml docker-compose.yaml docker-compose.yml; do
    if [[ -f "$f" ]]; then printf '%s' "$f"; return 0; fi
  done
  return 0
}

# ---------------------------------------------------------------------------
# Desafio 0 — Docker funciona? (feito antes da aula)
# ---------------------------------------------------------------------------
verificar_00() {
  if ! command -v docker >/dev/null 2>&1; then
    falhar "O comando docker não está instalado." "Num Codespace ele já vem. Em outra máquina: https://docs.docker.com/get-docker/"
    return
  fi
  if ! docker_ok; then
    falhar "O serviço do Docker (daemon) não respondeu." \
      "Num Codespace, espere um minuto depois de abrir e tente de novo. Em outra máquina: sudo systemctl start docker"
    return
  fi
  docker compose version >/dev/null 2>&1 || falhar "O plugin docker compose não está disponível." \
    "Num Codespace ele já vem. Em outra máquina, instale o Docker Compose v2 (docker compose, sem hífen)."
  if [[ -z "$(containers_de hello-world)" ]]; then
    falhar "Nenhum container foi criado a partir da imagem hello-world." "docker run hello-world"
  fi
  local faltam=() img
  for img in "${IMAGENS_BASE[@]}"; do imagem_existe "$img" || faltam+=("$img"); done
  (( ${#faltam[@]} == 0 )) || falhar "Imagens-base ainda não baixadas: ${faltam[*]}" "Rode setup.sh (ele baixa tudo o que a aula usa)."
  if (( ${#FALHAS[@]} == 0 )); then
    info "Docker $(docker version -f '{{.Server.Version}}' 2>/dev/null) · $(docker compose version --short 2>/dev/null | sed 's/^/Compose /')"
  fi
}

# ---------------------------------------------------------------------------
# Desafio 1 — Olá, container
# ---------------------------------------------------------------------------
verificar_01() {
  [[ -n "$(containers_de hello-world)" ]] || falhar "Nenhum container da imagem hello-world." "docker run hello-world"
  local id achou=0
  for id in $(containers_de python:3.12-slim); do
    [[ "$(container_cmd "$id")" == *print* ]] && achou=1
  done
  (( achou )) || falhar "Não encontrei um container criado a partir de python:3.12-slim executando um print." \
    "docker run python:3.12-slim python -c \"print('Olá, Docker!')\""
  local n; n="$(docker ps -aq | wc -l | tr -d ' ')"
  (( ${#FALHAS[@]} == 0 )) && info "docker ps -a lista $n container(s), todos parados: cada docker run criou um."
  return 0
}

# ---------------------------------------------------------------------------
# Desafio 2 — Dentro do container
# ---------------------------------------------------------------------------
verificar_02() {
  if ! container_existe explorador; then
    falhar "Não existe um container chamado 'explorador'." "docker run -it --name explorador python:3.12-slim bash"
  else
    local marca; marca="$(ler_do_container explorador /marca.txt)"
    if [[ -z "$marca" ]]; then
      falhar "Dentro do 'explorador' não há o arquivo /marca.txt." \
        "Dentro do container: echo \"eu estive aqui\" > /marca.txt. Se já saiu, entre de novo com docker start -ai explorador"
    elif [[ "${marca,,}" != *"estive aqui"* ]]; then
      falhar "/marca.txt existe, mas não contém 'eu estive aqui'." "echo \"eu estive aqui\" > /marca.txt (dentro do container)"
    fi
  fi
  local id sobras=0
  for id in $(containers_de python:3.12-slim); do
    [[ "$(container_cmd "$id")" == python3 ]] && sobras=$((sobras + 1))
  done
  (( sobras == 0 )) || falhar "Sobraram $sobras container(s) do Python interativo parados, sem nome." \
    "Foi sem --rm? Remova com docker rm \$(docker ps -aq --filter ancestor=python:3.12-slim --filter status=exited) e, da próxima vez, use docker run -it --rm ..."
  return 0
}

# ---------------------------------------------------------------------------
# Desafio 3 — Ciclo de vida
# ---------------------------------------------------------------------------
verificar_03() {
  local run="docker run -d --name relogio alpine sh -c 'while true; do date; sleep 1; done'"
  if exigir_container_rodando relogio "$run"; then
    [[ -n "$(docker logs --tail 3 relogio 2>&1)" ]] || falhar "O 'relogio' está rodando, mas não escreve nada nos logs." \
      "O comando dele deveria imprimir a hora a cada segundo: $run"
    local s; s="$(segundos_ate_ultimo_start relogio)"
    (( s >= 2 )) || falhar "O 'relogio' nunca foi parado e iniciado de novo (o último start foi na criação)." \
      "docker stop relogio, veja docker ps -a, e depois docker start relogio"
  fi
  ! container_existe descartavel || falhar "O container 'descartavel' ainda existe." \
    "Pare e remova: docker stop descartavel && docker rm descartavel (ou docker rm -f descartavel)"
  return 0
}

# ---------------------------------------------------------------------------
# Desafio 4 — Meu primeiro Dockerfile
# ---------------------------------------------------------------------------
verificar_04() {
  exigir_dockerfile || return 0
  [[ -n "$(linha_da FROM python)" ]] || falhar "O Dockerfile não começa com FROM python:..." "Primeira linha: FROM python:3.12-slim"
  [[ -n "$(linha_da COPY)" ]] || falhar "O Dockerfile não tem uma instrução COPY." "COPY receitas.py /app/receitas.py"
  [[ -n "$(linha_da CMD)" ]] || falhar "O Dockerfile não tem uma instrução CMD." 'CMD ["python", "/app/receitas.py"]'
  if ! imagem_existe receitas:1.0; then
    falhar "A imagem receitas:1.0 não existe." "docker build -t receitas:1.0 ."
    return 0
  fi
  local saida; saida="$(timeout 30 docker run --rm receitas:1.0 2>&1 || true)"
  if [[ "$saida" != *"Bolo de cenoura"* ]]; then
    falhar "docker run --rm receitas:1.0 não imprimiu o livro de receitas. Saída: $(echo "$saida" | head -3 | tr '\n' ' ')" \
      "O CMD deve rodar o receitas.py no caminho para onde o COPY o levou. Corrija e faça build de novo."
  fi
  if imagem_existe receitas:latest && [[ "$(imagem_id receitas:latest)" == "$(imagem_id receitas:1.0)" ]]; then
    extra_ok
  else
    extra_nao
  fi
}

# ---------------------------------------------------------------------------
# Desafio 5 — Instalando dependências
# ---------------------------------------------------------------------------
verificar_05() {
  exigir_dockerfile || return 0
  [[ -n "$(linha_da WORKDIR)" ]] || falhar "O Dockerfile não define WORKDIR." "WORKDIR /app"
  [[ -n "$(linha_da RUN 'pip')" ]] || falhar "O Dockerfile não instala as dependências com pip." \
    "RUN pip install --no-cache-dir -r requirements.txt"
  if ! imagem_existe receitas-api:1.0; then
    falhar "A imagem receitas-api:1.0 não existe." "docker build -t receitas-api:1.0 ."
    return 0
  fi
  if ! timeout 30 docker run --rm receitas-api:1.0 python -c "import fastapi, uvicorn" >/dev/null 2>&1; then
    falhar "Dentro da imagem receitas-api:1.0 o FastAPI não está instalado." \
      "O RUN pip install precisa vir depois do COPY do requirements.txt. Corrija e faça build de novo."
  fi
  local cmd; cmd="$(docker image inspect -f '{{join .Config.Cmd " "}}' receitas-api:1.0 2>/dev/null || true)"
  [[ "$cmd" == *app.py* ]] || falhar "O CMD da imagem ('$cmd') não roda o app.py." 'CMD ["python", "app.py"]'
}

# ---------------------------------------------------------------------------
# Desafio 6 — Camadas e cache
# ---------------------------------------------------------------------------
verificar_06() {
  exigir_dockerfile || return 0
  local l_req l_pip l_copy
  l_req="$(linha_da COPY requirements)"; l_pip="$(linha_da RUN pip)"; l_copy="$(linha_da COPY '\. ')"
  [[ -z "$l_copy" ]] && l_copy="$(linha_da COPY 'app.py')"
  if [[ -z "$l_req" ]]; then
    falhar "O Dockerfile não copia o requirements.txt separadamente." "Antes do pip install: COPY requirements.txt ."
  elif [[ -n "$l_pip" && "$l_req" -gt "$l_pip" ]]; then
    falhar "O COPY requirements.txt (linha $l_req) vem depois do RUN pip (linha $l_pip)." "O pip precisa do arquivo: copie-o antes."
  fi
  if [[ -n "$l_copy" && -n "$l_pip" && "$l_copy" -lt "$l_pip" ]]; then
    falhar "O COPY . . (linha $l_copy) vem antes do RUN pip install (linha $l_pip): qualquer mudança no código invalida o cache do pip." \
      "Ordem: COPY requirements.txt . → RUN pip install → COPY . ."
  fi
  if ! imagem_existe receitas-api:1.1; then
    falhar "A imagem receitas-api:1.1 não existe." "docker build -t receitas-api:1.1 ."
    return 0
  fi
  local original; original="$(app_py)"
  if [[ "$(cat app.py)" == "$original" ]]; then
    falhar "O app.py ainda é o original: o desafio pede uma mudança no código (uma receita nova) para ver o cache em ação." \
      "Acrescente uma receita à lista RECEITAS em app.py e rode docker build -t receitas-api:1.1 . de novo"
  fi
  local dentro; dentro="$(timeout 30 docker run --rm receitas-api:1.1 cat /app/app.py 2>/dev/null || true)"
  if [[ "$dentro" != "$(cat app.py)" ]]; then
    falhar "O app.py dentro da imagem receitas-api:1.1 é diferente do app.py da pasta." \
      "Depois de editar, é preciso construir de novo: docker build -t receitas-api:1.1 ."
  fi
}

# ---------------------------------------------------------------------------
# Desafio 7 — O que não entra na imagem
# ---------------------------------------------------------------------------
verificar_07() {
  [[ -f .dockerignore ]] || falhar "Não há um arquivo .dockerignore nesta pasta." \
    "Crie .dockerignore com um padrão por linha: .venv, __pycache__, .env, notas-pessoais.md, fotos"
  if ! imagem_existe receitas-api:1.2; then
    falhar "A imagem receitas-api:1.2 não existe." "docker build -t receitas-api:1.2 ."
    return 0
  fi
  local lista; lista="$(timeout 30 docker run --rm receitas-api:1.2 ls -A /app 2>/dev/null || true)"
  if [[ -z "$lista" ]]; then
    falhar "Não consegui listar /app dentro da imagem." "Confira o WORKDIR /app e o COPY . . no Dockerfile."
    return 0
  fi
  grep -qx 'app.py' <<<"$lista" || falhar "app.py não está em /app dentro da imagem." "O .dockerignore está ignorando demais? Ele não pode excluir app.py nem requirements.txt."
  local p
  # Se o .dockerignore foi editado mas a imagem não foi reconstruída, o lixo
  # continua lá dentro: a dica já cobre os dois casos.
  for p in .venv __pycache__ .env notas-pessoais.md fotos; do
    if grep -qx "$p" <<<"$lista"; then
      falhar "'$p' foi parar dentro da imagem." "Acrescente '$p' ao .dockerignore (se ainda não está) e faça build de novo: docker build -t receitas-api:1.2 ."
    fi
  done
}

# ---------------------------------------------------------------------------
# Desafio 8 — Abrindo portas
# ---------------------------------------------------------------------------
verificar_08() {
  exigir_dockerfile || return 0
  [[ -n "$(linha_da EXPOSE 8000)" ]] || falhar "O Dockerfile não documenta a porta com EXPOSE." "EXPOSE 8000 (antes do CMD)"
  if ! imagem_existe receitas-api:1.3; then
    falhar "A imagem receitas-api:1.3 não existe." "docker build -t receitas-api:1.3 ."
    return 0
  fi
  local run="docker run -d --name api -p 8001:8000 receitas-api:1.3"
  exigir_container_rodando api "$run" || return 0
  exigir_imagem_do_container api receitas-api:1.3
  exigir_porta api 8000 8001 http://localhost:8001/receitas "Bolo de cenoura" || return 0
  local exp; exp="$(docker image inspect -f '{{json .Config.ExposedPorts}}' receitas-api:1.3 2>/dev/null || true)"
  [[ "$exp" == *8000* ]] || falhar "A imagem receitas-api:1.3 não tem a porta 8000 em EXPOSE (foi construída antes de você editar o Dockerfile?)." \
    "docker build -t receitas-api:1.3 . e depois docker rm -f api && $run"
}

# ---------------------------------------------------------------------------
# Desafio 9 — Configuração por ambiente
# ---------------------------------------------------------------------------
verificar_09() {
  exigir_dockerfile || return 0
  [[ -n "$(linha_da ENV COZINHA)" ]] || falhar "O Dockerfile não define um valor padrão para COZINHA." 'ENV COZINHA="Cozinha do Curso"'
  if ! imagem_existe receitas-api:1.4; then
    falhar "A imagem receitas-api:1.4 não existe." "docker build -t receitas-api:1.4 ."
    return 0
  fi
  local padrao; padrao="$(imagem_env receitas-api:1.4 COZINHA)"
  [[ -n "$padrao" ]] || falhar "A imagem receitas-api:1.4 não carrega a variável COZINHA (foi construída antes do ENV?)." \
    "docker build -t receitas-api:1.4 ."
  local run='docker run -d --name cozinha -p 8002:8000 -e COZINHA="Cozinha da Ana" receitas-api:1.4'
  exigir_container_rodando cozinha "$run" || return 0
  exigir_imagem_do_container cozinha receitas-api:1.4
  local valor; valor="$(container_env cozinha COZINHA)"
  if [[ -z "$valor" ]]; then
    falhar "O container 'cozinha' não tem a variável COZINHA." "docker rm -f cozinha && $run"
  elif [[ -n "$padrao" && "$valor" == "$padrao" ]]; then
    falhar "O container 'cozinha' usa o mesmo valor da imagem ('$valor'); o desafio pede outro, passado no docker run." \
      "docker rm -f cozinha && $run"
  fi
  exigir_porta cozinha 8000 8002 http://localhost:8002/ "$valor" || return 0
  if [[ "$valor" == "Cozinha da Vovó" ]]; then extra_ok; else extra_nao; fi
}

# ---------------------------------------------------------------------------
# Desafio 10 — Editando ao vivo
# ---------------------------------------------------------------------------
verificar_10() {
  if ! imagem_existe receitas-api:1.5; then
    falhar "A imagem receitas-api:1.5 não existe." "docker build -t receitas-api:1.5 ."
    return 0
  fi
  local run="docker run -d --name dev -p 8003:8000 -v \"\$PWD:/app\" receitas-api:1.5"
  exigir_container_rodando dev "$run" || return 0
  exigir_imagem_do_container dev receitas-api:1.5
  local montagens; montagens="$(docker container inspect -f '{{range .Mounts}}{{.Type}} {{.Source}} {{.Destination}}{{"\n"}}{{end}}' dev)"
  if ! grep -qF "bind $PWD /app" <<<"$montagens"; then
    falhar "O container 'dev' não tem esta pasta montada em /app (montagens: ${montagens:-nenhuma})." \
      "docker rm -f dev && $run   (rode de dentro da pasta do desafio)"
  fi
  grep -q 'Pudim' app.py || falhar "O app.py desta pasta ainda não tem a receita de Pudim." \
    "Edite app.py no VS Code e acrescente {\"nome\": \"Pudim\", \"rende\": \"8 porções\"} à lista RECEITAS."
  exigir_porta dev 8000 8003 http://localhost:8003/receitas "Pudim" \
    "A API não mostra o Pudim. Salvou o arquivo? O container recarrega sozinho (reload=True); veja docker logs dev" || return 0
  local dentro; dentro="$(timeout 30 docker run --rm receitas-api:1.5 cat /app/app.py 2>/dev/null || true)"
  if [[ "$dentro" != *Pudim* ]]; then
    info "A imagem receitas-api:1.5 continua sem o Pudim, e mesmo assim a API mostra: é o bind mount, não a imagem, que o container está lendo."
  fi
}

# ---------------------------------------------------------------------------
# Desafio 11 — Dados que ficam
# ---------------------------------------------------------------------------
verificar_11() {
  imagem_existe bloco:1.0 || falhar "A imagem bloco:1.0 não existe." "docker build -t bloco:1.0 ."
  if ! volume_existe notas; then
    falhar "O volume 'notas' não existe." "docker volume create notas"
    return 0
  fi
  local conteudo; conteudo="$(timeout 30 docker run --rm -v notas:/dados alpine cat /dados/notas.txt 2>/dev/null || true)"
  local n; n="$(grep -c . <<<"$conteudo" || true)"
  if (( n == 0 )); then
    falhar "O volume 'notas' existe, mas está vazio." \
      "docker run --rm -v notas:/dados bloco:1.0 \"comprar cenouras\"   (o -v liga o volume à pasta /dados do container)"
  elif (( n < 2 )); then
    falhar "Só há 1 nota no volume; o desafio pede pelo menos 2, gravadas por containers diferentes." \
      "Rode de novo com outra nota: docker run --rm -v notas:/dados bloco:1.0 \"assar o bolo\""
  fi
}

# ---------------------------------------------------------------------------
# Desafio 12 — Site estático
# ---------------------------------------------------------------------------
verificar_12() {
  exigir_dockerfile || return 0
  [[ -n "$(linha_da FROM nginx)" ]] || falhar "O Dockerfile não parte de uma imagem do nginx." "FROM nginx:alpine"
  [[ -n "$(linha_da COPY)" ]] || falhar "O Dockerfile não copia o site para dentro da imagem." "COPY site/ /usr/share/nginx/html/"
  if ! imagem_existe receitas-web:1.0; then
    falhar "A imagem receitas-web:1.0 não existe." "docker build -t receitas-web:1.0 ."
    return 0
  fi
  local run="docker run -d --name web -p 8080:80 receitas-web:1.0"
  exigir_container_rodando web "$run" || return 0
  exigir_imagem_do_container web receitas-web:1.0
  exigir_porta web 80 8080 http://localhost:8080/ "Livro de receitas" \
    "O nginx respondeu, mas não com o nosso site. O COPY levou o site/ para /usr/share/nginx/html/?" || return 0
  local js; js="$(http_get http://localhost:8080/app.js)"
  [[ "$js" == *receitas* ]] || falhar "http://localhost:8080/app.js não responde: o site foi copiado sem o app.js?" \
    "COPY site/ /usr/share/nginx/html/ (o destino é a pasta do nginx, não uma subpasta) e build de novo."
  local json; json="$(http_get http://localhost:8080/receitas.json)"
  [[ "$json" == *"Bolo"* ]] || falhar "http://localhost:8080/receitas.json não responde." "O receitas.json também precisa estar em /usr/share/nginx/html/."
}

# ---------------------------------------------------------------------------
# Desafio 13 — Containers conversando
# ---------------------------------------------------------------------------
verificar_13() {
  imagem_existe receitas-api:1.6 || falhar "A imagem receitas-api:1.6 não existe." "docker build -t receitas-api:1.6 ."
  if ! rede_existe cozinha; then
    falhar "A rede 'cozinha' não existe." "docker network create cozinha"
    return 0
  fi
  local run="docker run -d --name receitas --network cozinha receitas-api:1.6"
  exigir_container_rodando receitas "$run" || return 0
  local redes; redes="$(docker container inspect -f '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}' receitas)"
  if [[ " $redes " != *" cozinha "* ]]; then
    falhar "O container 'receitas' não está na rede 'cozinha' (está em: $redes)." "docker rm -f receitas && $run"
    return 0
  fi
  local resposta
  resposta="$(timeout 40 docker run --rm --network cozinha python:3.12-slim \
    python -c "import urllib.request; print(urllib.request.urlopen('http://receitas:8000/receitas', timeout=5).read().decode())" 2>&1 || true)"
  if [[ "$resposta" != *"Bolo de cenoura"* ]]; then
    falhar "De dentro da rede 'cozinha', http://receitas:8000/receitas não respondeu: $(echo "$resposta" | tail -1)" \
      "O nome do container (receitas) é o nome de rede. Veja docker logs receitas e docker network inspect cozinha"
  fi
  if [[ -z "$(porta_publicada receitas 8000)" ]]; then extra_ok; else extra_nao; fi
}

# ---------------------------------------------------------------------------
# Desafio 14 — Docker Compose
# ---------------------------------------------------------------------------
verificar_14() {
  if [[ -z "$(arquivo_compose)" ]]; then
    falhar "Não há um arquivo compose.yaml nesta pasta." "Crie compose.yaml com os serviços api e web (veja o enunciado)."
    return 0
  fi
  if ! docker compose config >/dev/null 2>&1; then
    falhar "O compose.yaml tem um erro de sintaxe." "Veja a mensagem de docker compose config. Cuidado com a indentação (dois espaços)."
    return 0
  fi
  local servicos; servicos="$(docker compose config --services 2>/dev/null | sort | tr '\n' ' ')"
  [[ " $servicos" == *" api "* ]] || falhar "O compose.yaml não define o serviço 'api' (tem: ${servicos:-nenhum})." "services: → api: → build: ./api"
  [[ " $servicos" == *" web "* ]] || falhar "O compose.yaml não define o serviço 'web' (tem: ${servicos:-nenhum})." "services: → web: → build: ./web"
  local rodando; rodando="$(docker compose ps --services --filter status=running 2>/dev/null | sort | tr '\n' ' ' || true)"
  local s
  for s in api web; do
    [[ " $rodando" == *" $s "* ]] || falhar "O serviço '$s' não está rodando (rodando: ${rodando:-nenhum})." \
      "docker compose up -d --build   e depois   docker compose ps   e   docker compose logs $s"
  done
  (( ${#FALHAS[@]} == 0 )) || return 0
  local html; html="$(http_get http://localhost:8090/)"
  [[ "$html" == *"Livro de receitas"* ]] || falhar "http://localhost:8090/ não responde com o site." \
    "No serviço web: ports: → - \"8090:80\". Depois docker compose up -d"
  local json; json="$(http_get http://localhost:8090/api/receitas)"
  [[ "$json" == *"Bolo de cenoura"* ]] || falhar "http://localhost:8090/api/receitas não chega até a API." \
    "O nginx repassa /api/ para http://api:8000/: o serviço precisa se chamar exatamente 'api'. Veja docker compose logs web"
}

# ---------------------------------------------------------------------------
# Desafio 15 — Faxina
# ---------------------------------------------------------------------------
verificar_15() {
  local rodando parados
  rodando="$(docker ps -q | wc -l | tr -d ' ')"
  parados="$(docker ps -aq --filter status=exited --filter status=created | wc -l | tr -d ' ')"
  (( rodando == 0 )) || falhar "Ainda há $rodando container(s) rodando." "docker stop \$(docker ps -q)"
  (( parados == 0 )) || falhar "Ainda há $parados container(s) parado(s)." "docker container prune"
  local penduradas; penduradas="$(docker images -q --filter dangling=true | wc -l | tr -d ' ')"
  (( penduradas == 0 )) || falhar "Há $penduradas imagem(ns) sem nome (<none>), sobras de builds antigos." "docker image prune"
  local sobras=() v r i
  for v in "${VOLUMES_DO_CURSO[@]}"; do volume_existe "$v" && sobras+=("volume $v"); done
  for r in "${REDES_DO_CURSO[@]}"; do rede_existe "$r" && sobras+=("rede $r"); done
  for i in "${IMAGENS_DO_CURSO[@]}"; do
    [[ -n "$(docker images -q "$i" 2>/dev/null)" ]] && sobras+=("imagem $i")
  done
  if (( ${#sobras[@]} == 0 )); then extra_ok; else extra_nao; info "Ainda existem: ${sobras[*]} (missão extra)."; fi
  return 0
}

# ---------------------------------------------------------------------------
# Relatório
# ---------------------------------------------------------------------------
relatorio() {
  local nn="$1"
  local titulo; titulo="Desafio $nn — $(lab_nome "$nn")"
  if (( ${#FALHAS[@]} == 0 )); then
    ok "${C_NEG}$titulo${C_FIM}: concluído! 🎉"
  else
    erro "${C_NEG}$titulo${C_FIM}: ainda não. Encontrei ${#FALHAS[@]} ponto(s) para ajustar:"
    local f
    for f in "${FALHAS[@]}"; do printf '\n • %s\n' "$f"; done
    printf '\n'
  fi
  case "$EXTRA" in
    ok)  ok "Missão extra: concluída!" ;;
    nao) info "Missão extra: ainda não (opcional)." ;;
  esac
  (( ${#FALHAS[@]} == 0 ))
}
