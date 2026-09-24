#!/usr/bin/env bash
# Prepara o ambiente do curso: confere o Docker, baixa as imagens-base que a
# aula usa, aquece o cache de build e gera os laboratórios em $LABS_DIR
# (por padrão ~/labs).
#
# Uso:
#   setup.sh            # gera só o que ainda não existe (idempotente)
#   setup.sh --force    # apaga e regenera todos os laboratórios
#
# O install.sh roda este script automaticamente.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
source "$SCRIPTS_DIR/labs.sh"

FORCE=0
[[ "${1:-}" == "--force" ]] && FORCE=1

# --- Docker -----------------------------------------------------------------
exigir_docker || exit 1
info "Docker $(docker version -f '{{.Server.Version}}') · Compose $(docker compose version --short 2>/dev/null || echo 'não encontrado')"

# --- Imagens-base ----------------------------------------------------------------
# Baixadas agora para que, na aula, nenhum desafio dependa da velocidade da rede.
for img in "${IMAGENS_BASE[@]}"; do
  if imagem_existe "$img"; then
    info "Imagem $img já está aqui"
  else
    info "Baixando a imagem $img ..."
    docker pull -q "$img" >/dev/null || aviso "Não consegui baixar $img agora; o Docker tenta de novo no primeiro docker run."
  fi
done

# --- Cache de build ----------------------------------------------------------------
# Os Dockerfiles dos desafios 6 em diante instalam o FastAPI com as mesmas
# instruções. Construir uma vez aqui deixa essas camadas no cache do BuildKit,
# e os builds da aula viram questão de segundos. A imagem em si é descartada.
aquecer_cache() {
  local tmp; tmp="$(mktemp -d)"
  requirements_txt > "$tmp/requirements.txt"
  app_py > "$tmp/app.py"
  dockerfile_api bom > "$tmp/Dockerfile"
  if docker build -q -t curso-docker-aquecimento "$tmp" >/dev/null 2>&1; then
    rm_imagem curso-docker-aquecimento
    info "Cache de build aquecido (FastAPI instalado uma vez, por conta do curso)"
  else
    aviso "Não consegui aquecer o cache de build; o primeiro build da aula vai demorar um pouco mais."
  fi
  rm -rf "$tmp"
}
aquecer_cache

# --- Laboratórios --------------------------------------------------------------
mkdir -p "$LABS_DIR"
info "Laboratórios em: $LABS_DIR"

gerados=0; mantidos=0
for n in $(seq "$PRIMEIRO_LAB_COM_PASTA" "$ULTIMO_LAB_COM_PASTA"); do
  nn="$(printf '%02d' "$n")"
  dir="$(lab_dir "$nn")"
  if [[ -d "$dir" && $FORCE -eq 0 ]]; then
    mantidos=$((mantidos + 1))
    continue
  fi
  gerar_lab "$nn"
  gerados=$((gerados + 1))
done

ok "Pronto: $gerados laboratório(s) gerado(s), $mantidos mantido(s)."
if (( mantidos > 0 )); then
  info "Para recomeçar um desafio específico: reset.sh NN"
fi
