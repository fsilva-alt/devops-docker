#!/usr/bin/env bash
# Suíte de testes DE DESENVOLVIMENTO do curso (não é usada na aula).
#
# Para cada desafio, exercita três situações e confere a resposta de check.sh:
#   vazio  -> o aluno não fez nada: deve reprovar;
#   errado -> o aluno fez algo plausível, mas incorreto: deve reprovar com a dica certa;
#   certo  -> a solução do gabarito: deve aprovar (e reconhecer a missão extra, quando há).
#
# Roda dentro do container de tests/Dockerfile (veja tests/rodar.sh), um Docker
# completo e descartável: a primeira etapa é o próprio install.sh, apontado para
# uma cópia da árvore de trabalho atual. Também funciona em qualquer máquina com
# Docker, desde que HOME seja descartável e o Docker também (a suíte apaga todos
# os containers, volumes e redes antes de começar).

set -euo pipefail

FONTE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"   # o repositório em desenvolvimento
export LANG=C.UTF-8
unset LABS_DIR                  # o instalador decide (~/labs)

if [[ -t 1 ]]; then C_VERDE=$'\e[32m'; C_VERM=$'\e[31m'; C_NEG=$'\e[1m'; C_FIM=$'\e[0m'; else C_VERDE=""; C_VERM=""; C_NEG=""; C_FIM=""; fi
ok()   { printf '%s\n' "${C_VERDE}✅${C_FIM} $*"; }
erro() { printf '%s\n' "${C_VERM}❌${C_FIM} $*" >&2; }

TOTAL=0; OKS=0; FALHOU=0
CHECK=check.sh

passo() { printf '\n%s\n' "${C_NEG}== $*${C_FIM}"; }
conta_ok() { TOTAL=$((TOTAL + 1)); OKS=$((OKS + 1)); ok "$*"; }
conta_falha() { TOTAL=$((TOTAL + 1)); FALHOU=1; erro "$*"; }

# reprova NN "rótulo" ["trecho esperado na saída"]
reprova() {
  local nn="$1" rotulo="$2" trecho="${3:-}" saida
  if saida="$("$CHECK" "$nn" 2>&1)"; then
    conta_falha "$nn $rotulo: check.sh aprovou, mas deveria reprovar"; printf '%s\n' "$saida"; return
  fi
  if [[ -n "$trecho" ]] && ! grep -qF -- "$trecho" <<<"$saida"; then
    conta_falha "$nn $rotulo: reprovou, mas sem a dica esperada ('$trecho')"; printf '%s\n' "$saida"; return
  fi
  conta_ok "$nn $rotulo: reprova${trecho:+ e aponta '$trecho'}"
}

# aprova NN "rótulo" [extra]
aprova() {
  local nn="$1" rotulo="$2" extra="${3:-}" saida
  if ! saida="$("$CHECK" "$nn" 2>&1)"; then
    conta_falha "$nn $rotulo: check.sh reprovou, mas deveria aprovar"; printf '%s\n' "$saida"; return
  fi
  if [[ "$extra" == "extra" ]] && ! grep -q 'Missão extra: concluída' <<<"$saida"; then
    conta_falha "$nn $rotulo: aprovou, mas não reconheceu a missão extra"; printf '%s\n' "$saida"; return
  fi
  conta_ok "$nn $rotulo: aprova${extra:+ (com missão extra)}"
}

recomeca() { reset.sh "$1" >/dev/null; if lab_tem_pasta "$1"; then cd "$(lab_dir "$1")"; fi; }
build() { docker build -q -t "$1" . >/dev/null; }
run_d() { docker run -d "$@" >/dev/null; }

# esperar_http URL — espera (até ~10 s) um servidor recém-iniciado responder
esperar_http() {
  local i
  for i in $(seq 1 20); do
    curl -sf --max-time 3 "$1" >/dev/null 2>&1 && return 0
    sleep 0.5
  done
  return 1
}

# ---------------------------------------------------------------------------
passo "Instalador (install.sh) num ambiente em branco"
rm -rf "$HOME/labs" "$HOME/devops-docker"
sed -i '/# >>> curso de docker >>>/,/# <<< curso de docker <<</d' "$HOME/.bashrc" "$HOME/.zshrc" 2>/dev/null || true
touch "$HOME/.zshrc"
# Docker em branco: sem containers, volumes, redes nem imagens do curso.
# As imagens-base ficam (o cache de tests/rodar.sh existe para isso).
docker rm -f $(docker ps -aq) >/dev/null 2>&1 || true
docker volume prune -af >/dev/null 2>&1 || true
docker network prune -f >/dev/null 2>&1 || true
for padrao in 'receitas*' bloco '*-api' '*-web'; do
  docker image rm -f $(docker images -q "$padrao" 2>/dev/null | sort -u) >/dev/null 2>&1 || true
done
docker image prune -f >/dev/null 2>&1 || true

# O "GitHub" de onde o curl baixaria: uma cópia commitada da árvore de trabalho atual
ORIGEM="$(mktemp -d)/devops-docker"
mkdir -p "$ORIGEM"
cp -r "$FONTE_DIR"/. "$ORIGEM"
rm -rf "$ORIGEM/.git"
git -C "$ORIGEM" init -q -b main
git -C "$ORIGEM" -c user.name=dev -c user.email=dev@exemplo.com add -A
git -C "$ORIGEM" -c user.name=dev -c user.email=dev@exemplo.com commit -q -m "Versão em teste"

cd /tmp   # o instalador tem de funcionar de qualquer pasta (ele faz cd $HOME)
saida="$(CURSO_REPO="$ORIGEM" sh "$ORIGEM/install.sh" 2>&1)" \
  && conta_ok "install.sh roda com sh (POSIX) e termina sem erro" \
  || { conta_falha "install.sh falhou"; printf '%s\n' "$saida"; exit 1; }
grep -q 'instalado com sucesso' <<<"$saida" && conta_ok "install.sh mostra a mensagem de sucesso" \
  || conta_falha "install.sh não mostrou a mensagem de sucesso"
grep -q 'check.sh 00' <<<"$saida" && conta_ok "install.sh indica o primeiro passo" \
  || conta_falha "install.sh não indicou o próximo passo"
[[ -x "$HOME/devops-docker/scripts/check.sh" ]] && conta_ok "curso clonado em ~/devops-docker" \
  || conta_falha "~/devops-docker/scripts/check.sh não existe"
[[ -d "$HOME/labs/04-meu-primeiro-dockerfile" && -d "$HOME/labs/14-docker-compose/web/site" ]] \
  && conta_ok "laboratórios gerados em ~/labs" || conta_falha "laboratórios não foram gerados em ~/labs"
grep -q 'devops-docker/scripts' "$HOME/.bashrc" && conta_ok "PATH adicionado ao ~/.bashrc" \
  || conta_falha "PATH não foi adicionado ao ~/.bashrc"
grep -q 'devops-docker/scripts' "$HOME/.zshrc" && conta_ok "PATH adicionado ao ~/.zshrc" \
  || conta_falha "PATH não foi adicionado ao ~/.zshrc"
bash -ic 'command -v check.sh' >/dev/null 2>&1 && conta_ok "check.sh disponível num shell novo" \
  || conta_falha "check.sh não está no PATH de um shell novo"
faltam=""
for img in hello-world alpine python:3.12-slim nginx:alpine; do docker image inspect "$img" >/dev/null 2>&1 || faltam="$faltam $img"; done
[[ -z "$faltam" ]] && conta_ok "setup.sh baixou as imagens-base" || conta_falha "imagens-base faltando:$faltam"
docker image inspect curso-docker-aquecimento >/dev/null 2>&1 && conta_falha "setup.sh deixou a imagem de aquecimento para trás" \
  || conta_ok "setup.sh descartou a imagem de aquecimento"

# Rodar de novo: atualiza sem apagar nada e sem duplicar o PATH
touch "$HOME/labs/04-meu-primeiro-dockerfile/marca"
saida="$(CURSO_REPO="$ORIGEM" sh "$ORIGEM/install.sh" 2>&1)" && grep -q 'Atualizando' <<<"$saida" \
  && conta_ok "install.sh rodado de novo atualiza em vez de clonar" || conta_falha "segunda execução do install.sh"
[[ -f "$HOME/labs/04-meu-primeiro-dockerfile/marca" ]] && conta_ok "segunda execução preserva os labs" \
  || conta_falha "segunda execução apagou os labs"
(( $(grep -c '# >>> curso de docker >>>' "$HOME/.bashrc") == 1 )) && conta_ok "PATH não duplicado no ~/.bashrc" \
  || conta_falha "bloco do PATH duplicado no ~/.bashrc"
rm -f "$HOME/labs/04-meu-primeiro-dockerfile/marca"

# Daqui em diante, tudo usa a instalação feita pelo aluno
CURSO_DIR="$HOME/devops-docker"
export PATH="$CURSO_DIR/scripts:$PATH"
source "$CURSO_DIR/scripts/lib.sh"   # LABS_DIR, lab_dir, lab_tem_pasta, cores
source "$CURSO_DIR/scripts/labs.sh"  # dockerfile_api etc., para escrever as soluções

# ---------------------------------------------------------------------------
passo "Desafio 00 — Docker funciona?"
reprova 00 vazio "docker run hello-world"
docker run hello-world >/dev/null
aprova 00 certo

# ---------------------------------------------------------------------------
passo "Desafio 01 — Olá, container"
reprova 01 vazio "print"
docker run python:3.12-slim python --version >/dev/null
reprova 01 "errado (python sem print)" "print"
docker run python:3.12-slim python -c "print('Olá, Docker!')" | grep -q 'Olá' || conta_falha "01: o print não saiu do container"
aprova 01 certo

# ---------------------------------------------------------------------------
passo "Desafio 02 — Dentro do container"
reprova 02 vazio "explorador"
docker run --name explorador python:3.12-slim bash -c 'true'
reprova 02 "errado (entrou, mas sem marca)" "marca.txt"
recomeca 02
docker run python:3.12-slim >/dev/null 2>&1 || true           # o REPL sem --rm deixa um container parado
docker run --name explorador python:3.12-slim bash -c 'echo "eu estive aqui" > /marca.txt'
reprova 02 "errado (sobrou o Python interativo sem --rm)" "--rm"
for id in $(docker ps -aq --filter ancestor=python:3.12-slim); do
  [[ "$(docker inspect -f '{{join .Config.Cmd " "}}' "$id")" == python3 ]] && docker rm "$id" >/dev/null
done
docker run --rm python:3.12-slim cat /marca.txt >/dev/null 2>&1 && conta_falha "02: outro container não deveria ver /marca.txt" \
  || conta_ok "02 cada container tem o seu sistema de arquivos"
aprova 02 certo

# ---------------------------------------------------------------------------
passo "Desafio 03 — Ciclo de vida"
reprova 03 vazio "relogio"
run_d --name relogio alpine sh -c 'while true; do date; sleep 1; done'
run_d --name descartavel alpine sleep 600
reprova 03 "errado (nunca parou, descartavel vivo)" "nunca foi parado"
sleep 2
docker stop -t 1 relogio >/dev/null && docker start relogio >/dev/null
reprova 03 "errado (descartavel ainda existe)" "descartavel"
docker rm descartavel >/dev/null 2>&1 && conta_falha "03: docker rm de container rodando deveria falhar" \
  || conta_ok "03 docker rm recusa container rodando"
docker rm -f descartavel >/dev/null
aprova 03 certo
recomeca 03
run_d --name relogio alpine sleep 600
sleep 2; docker stop -t 1 relogio >/dev/null && docker start relogio >/dev/null
reprova 03 "errado (container sem logs)" "logs"

# ---------------------------------------------------------------------------
passo "Desafio 04 — Meu primeiro Dockerfile"
reprova 04 vazio "Dockerfile"
cd "$(lab_dir 04)"
printf 'FROM python:3.12-slim\nCOPY receitas.py /app/receitas.py\n' > Dockerfile
reprova 04 "errado (sem CMD)" "CMD"
printf 'CMD ["python", "/app/receitas.py"]\n' >> Dockerfile
reprova 04 "errado (sem build)" "docker build"
build receitas:1.0
aprova 04 certo
docker tag receitas:1.0 receitas:latest
aprova 04 "certo + extra" extra
printf 'FROM python:3.12-slim\nCOPY receitas.py /app/receitas.py\nCMD ["python", "receitas.py"]\n' > Dockerfile
build receitas:1.0
reprova 04 "errado (CMD com caminho errado)" "não imprimiu"

# ---------------------------------------------------------------------------
passo "Desafio 05 — Instalando dependências"
reprova 05 vazio "Dockerfile"
cd "$(lab_dir 05)"
printf 'FROM python:3.12-slim\nWORKDIR /app\nCOPY . .\nCMD ["python", "app.py"]\n' > Dockerfile
build receitas-api:1.0
reprova 05 "errado (sem pip install)" "pip"
dockerfile_api ingenuo > Dockerfile
build receitas-api:1.0
aprova 05 certo

# ---------------------------------------------------------------------------
passo "Desafio 06 — Camadas e cache"
reprova 06 vazio "separadamente"
cd "$(lab_dir 06)"
build receitas-api:1.1
reprova 06 "errado (build sem reordenar)" "separadamente"
dockerfile_api bom > Dockerfile
build receitas-api:1.1
reprova 06 "errado (ordem certa, app.py original)" "ainda é o original"
sed -i 's/^    {"nome": "Pão de queijo", "rende": "25 unidades"},$/&\n    {"nome": "Mousse de maracujá", "rende": "6 porções"},/' app.py
grep -q Mousse app.py || conta_falha "06: o sed não acrescentou a receita"
reprova 06 "errado (editou sem build)" "construir de novo"
build receitas-api:1.1
aprova 06 certo
printf 'FROM python:3.12-slim\nWORKDIR /app\nRUN pip install --no-cache-dir -r requirements.txt\nCOPY requirements.txt .\nCOPY . .\nCMD ["python", "app.py"]\n' > Dockerfile
reprova 06 "errado (pip antes do COPY requirements)" "vem depois do RUN pip"

# ---------------------------------------------------------------------------
passo "Desafio 07 — O que não entra na imagem"
reprova 07 vazio ".dockerignore"
cd "$(lab_dir 07)"
build receitas-api:1.2
reprova 07 "errado (build com lixo)" "foi parar dentro da imagem"
printf '.venv\n__pycache__\n' > .dockerignore
build receitas-api:1.2
reprova 07 "errado (esqueceu o .env)" "'.env' foi parar"
printf '.venv\n__pycache__\n.env\nnotas-pessoais.md\nfotos\n' > .dockerignore
reprova 07 "errado (.dockerignore corrigido, sem build)" "faça build de novo"
build receitas-api:1.2
aprova 07 certo

# ---------------------------------------------------------------------------
passo "Desafio 08 — Abrindo portas"
reprova 08 vazio "EXPOSE"
cd "$(lab_dir 08)"
sed -i 's/^CMD /EXPOSE 8000\n\nCMD /' Dockerfile
build receitas-api:1.3
reprova 08 "errado (sem container)" "docker run -d --name api"
run_d --name api receitas-api:1.3
reprova 08 "errado (sem -p)" "-p 8001:8000"
docker rm -f api >/dev/null
run_d --name api -p 8011:8000 receitas-api:1.3
reprova 08 "errado (porta de fora errada)" "pede a 8001"
docker rm -f api >/dev/null
run_d --name api -p 8001:8000 receitas-api:1.3
esperar_http localhost:8001/receitas || conta_falha "08: a API não subiu em 10 s"
aprova 08 certo
curl -sf localhost:8001/docs | grep -qi swagger && conta_ok "08 /docs do FastAPI responde" || conta_falha "08 /docs não respondeu"

# ---------------------------------------------------------------------------
passo "Desafio 09 — Configuração por ambiente"
reprova 09 vazio "ENV COZINHA"
cd "$(lab_dir 09)"
sed -i 's/^EXPOSE 8000$/ENV COZINHA="Cozinha do Curso"\n\nEXPOSE 8000/' Dockerfile
build receitas-api:1.4
run_d --name cozinha -p 8002:8000 receitas-api:1.4
reprova 09 "errado (sem -e: mesmo valor da imagem)" "mesmo valor da imagem"
docker rm -f cozinha >/dev/null
run_d --name cozinha -p 8002:8000 -e COZINHA="Cozinha da Ana" receitas-api:1.4
esperar_http localhost:8002/ || conta_falha "09: a API não subiu em 10 s"
aprova 09 certo
curl -sf localhost:8002/ | grep -q 'Cozinha da Ana' || conta_falha "09: a rota / não mostrou a cozinha"
docker rm -f cozinha >/dev/null
run_d --name cozinha -p 8002:8000 --env-file cozinha.env receitas-api:1.4
esperar_http localhost:8002/ || conta_falha "09: a API (env-file) não subiu em 10 s"
aprova 09 "certo + extra (env-file)" extra

# ---------------------------------------------------------------------------
passo "Desafio 10 — Editando ao vivo"
reprova 10 vazio "docker build"
cd "$(lab_dir 10)"
build receitas-api:1.5
run_d --name dev -p 8003:8000 receitas-api:1.5
reprova 10 "errado (sem bind mount)" "montada em /app"
docker rm -f dev >/dev/null
run_d --name dev -p 8003:8000 -v "$PWD:/app" receitas-api:1.5
reprova 10 "errado (não editou o app.py)" "Pudim"
sed -i 's/^    {"nome": "Pão de queijo", "rende": "25 unidades"},$/&\n    {"nome": "Pudim", "rende": "8 porções"},/' app.py
sleep 4   # o uvicorn percebe a mudança e reinicia
aprova 10 certo
docker run --rm receitas-api:1.5 grep -q Pudim app.py && conta_falha "10: a imagem não deveria ter o Pudim" \
  || conta_ok "10 a imagem continua sem o Pudim (é o bind mount)"

# ---------------------------------------------------------------------------
passo "Desafio 11 — Dados que ficam"
reprova 11 vazio "docker build -t bloco:1.0"
cd "$(lab_dir 11)"
build bloco:1.0
docker run --rm bloco:1.0 "comprar cenouras" >/dev/null
[[ "$(docker run --rm bloco:1.0 "assar o bolo" | grep -c '^[0-9]')" == "1" ]] \
  && conta_ok "11 sem volume, cada container começa do zero" || conta_falha "11: sem volume, a nota anterior não deveria existir"
reprova 11 "errado (sem volume)" "docker volume create notas"
docker volume create notas >/dev/null
reprova 11 "errado (volume vazio)" "está vazio"
docker run --rm -v notas:/dados bloco:1.0 "comprar cenouras" >/dev/null
reprova 11 "errado (só uma nota)" "pelo menos 2"
docker run --rm -v notas:/dados bloco:1.0 "assar o bolo" | grep -q '2. assar o bolo' || conta_falha "11: a segunda nota não apareceu"
aprova 11 certo

# ---------------------------------------------------------------------------
passo "Desafio 12 — Site estático"
reprova 12 vazio "Dockerfile"
cd "$(lab_dir 12)"
printf 'FROM nginx:alpine\nCOPY site/ /usr/share/nginx/html/site/\n' > Dockerfile
build receitas-web:1.0
run_d --name web -p 8080:80 receitas-web:1.0
reprova 12 "errado (site numa subpasta)" "não com o nosso site"
docker rm -f web >/dev/null
printf 'FROM nginx:alpine\nCOPY site/ /usr/share/nginx/html/\n' > Dockerfile
build receitas-web:1.0
reprova 12 "errado (imagem nova, container velho não existe)" "docker run -d --name web"
run_d --name web -p 8080:80 receitas-web:1.0
aprova 12 certo

# ---------------------------------------------------------------------------
passo "Desafio 13 — Containers conversando"
reprova 13 vazio "cozinha"
cd "$(lab_dir 13)"
build receitas-api:1.6
docker network create cozinha >/dev/null
reprova 13 "errado (sem container)" "--network cozinha"
run_d --name receitas receitas-api:1.6
reprova 13 "errado (fora da rede)" "não está na rede"
docker rm -f receitas >/dev/null
run_d --name receitas --network cozinha -p 8004:8000 receitas-api:1.6
aprova 13 "certo (com -p, sem extra)"
docker rm -f receitas >/dev/null
run_d --name receitas --network cozinha receitas-api:1.6
sleep 3   # o uvicorn ainda está subindo
docker run --rm --network cozinha -v "$PWD:/app" python:3.12-slim python /app/cliente.py | grep -q 'Bolo de cenoura' \
  && conta_ok "13 cliente.py acha a API pelo nome" || conta_falha "13: cliente.py não achou a API"
docker run --rm -v "$PWD:/app" python:3.12-slim python /app/cliente.py >/dev/null 2>&1 \
  && conta_falha "13: fora da rede o nome não deveria resolver" || conta_ok "13 fora da rede, o nome não resolve"
aprova 13 "certo + extra" extra

# ---------------------------------------------------------------------------
passo "Desafio 14 — Docker Compose"
reprova 14 vazio "compose.yaml"
cd "$(lab_dir 14)"
printf 'services:\n  api:\n    build: ./api\n' > compose.yaml
reprova 14 "errado (só a api)" "serviço 'web'"
printf 'services:\n  api:\n    build: ./api\n\n  web:\n    build: ./web\n    ports:\n      - "8090:80"\n    depends_on:\n      - api\n' > compose.yaml
reprova 14 "errado (sem up)" "docker compose up"
docker compose up -d --build --quiet-pull >/dev/null 2>&1
esperar_http localhost:8090/api/receitas || conta_falha "14: a API atrás do nginx não respondeu em 10 s"
aprova 14 certo
curl -sf localhost:8090/app.js | grep -q '/api/receitas' && conta_ok "14 o site pede as receitas em /api/receitas" \
  || conta_falha "14: o app.js do site deveria apontar para /api/receitas"
docker compose down >/dev/null 2>&1
reprova 14 "errado (depois do down)" "docker compose up"
docker compose up -d >/dev/null 2>&1
esperar_http localhost:8090/api/receitas || conta_falha "14: a API não voltou depois do up"
aprova 14 "certo (up de novo, sem build)"
printf 'services:\n  api:\n    build: ./api\n    environment:\n      COZINHA: "Cozinha do Compose"\n\n  web:\n    build: ./web\n    ports:\n      - "8090:80"\n    depends_on:\n      - api\n' > compose.yaml
docker compose up -d >/dev/null 2>&1
for _ in $(seq 1 20); do curl -sf localhost:8090/api/ 2>/dev/null | grep -q 'Cozinha do Compose' && break; sleep 0.5; done
curl -sf localhost:8090/api/ | grep -q 'Cozinha do Compose' && conta_ok "14 environment no compose chega à API (só o api foi recriado)" \
  || conta_falha "14: environment do compose não chegou à API"

# ---------------------------------------------------------------------------
passo "Desafio 15 — Faxina"
reprova 15 vazio "rodando"
docker stop -t 1 $(docker ps -q) >/dev/null
reprova 15 "errado (parados)" "docker container prune"
docker container prune -f >/dev/null
if [[ -n "$(docker images -q --filter dangling=true)" ]]; then
  reprova 15 "errado (imagens <none>)" "docker image prune"
  docker image prune -f >/dev/null
fi
aprova 15 certo
( cd "$(lab_dir 14)" && docker compose down >/dev/null 2>&1 )
docker volume rm notas >/dev/null
docker network rm cozinha >/dev/null
docker image rm -f $(docker images -q 'receitas*' | sort -u) bloco:1.0 >/dev/null 2>&1 || true
docker image rm -f $(docker images -q '14-docker-compose-*' | sort -u) >/dev/null 2>&1 || true
aprova 15 "certo + extra" extra

# ---------------------------------------------------------------------------
passo "Utilitários"
cd "$(lab_dir 13)"
saida="$(check.sh 2>&1 || true)"     # reprova (a faxina apagou tudo), mas tem de detectar o 13
grep -q 'Desafio 13' <<<"$saida" && conta_ok "check.sh sem argumento detecta o desafio pela pasta" \
  || { conta_falha "check.sh sem argumento não detectou o desafio"; printf '%s\n' "$saida"; }
cd "$CURSO_DIR"
setup.sh | grep -q '0 laboratório(s) gerado(s), 11 mantido(s)' && conta_ok "setup.sh é idempotente" \
  || conta_falha "setup.sh regenerou labs existentes"
[[ -f "$(lab_dir 14)/compose.yaml" ]] && conta_ok "setup.sh não apagou o trabalho" || conta_falha "setup.sh apagou o trabalho"
check.sh 99 >/dev/null 2>&1 && conta_falha "check.sh 99 deveria falhar" || conta_ok "check.sh rejeita número inválido"
reset.sh 00 >/dev/null 2>&1 && conta_falha "reset.sh 00 deveria falhar" || conta_ok "reset.sh recusa o desafio 00"
reset.sh 15 >/dev/null 2>&1 && conta_falha "reset.sh 15 deveria falhar" || conta_ok "reset.sh recusa o desafio 15"
cd "$(lab_dir 09)"
build receitas-api:1.4
run_d --name cozinha -p 8002:8000 -e COZINHA=x receitas-api:1.4
cd /tmp
reset.sh 09 >/dev/null
if ! docker container inspect cozinha >/dev/null 2>&1 && ! docker image inspect receitas-api:1.4 >/dev/null 2>&1 \
   && ! grep -q 'ENV COZINHA' "$(lab_dir 09)/Dockerfile"; then
  conta_ok "reset.sh 09 remove container, imagem e recria a pasta"
else
  conta_falha "reset.sh 09 deixou sobras"
fi
reset.sh 03 >/dev/null && conta_ok "reset.sh funciona em desafio sem pasta" || conta_falha "reset.sh 03 falhou"

# ---------------------------------------------------------------------------
passo "Resultado"
if (( FALHOU == 0 )); then
  ok "$OKS/$TOTAL verificações passaram."
else
  erro "$OKS/$TOTAL verificações passaram."
  exit 1
fi
