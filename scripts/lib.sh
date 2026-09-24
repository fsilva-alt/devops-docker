#!/usr/bin/env bash
# Biblioteca compartilhada pelos scripts do curso. Não execute este arquivo
# diretamente: ele é carregado (source) por setup.sh, check.sh e reset.sh.

set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSO_DIR="$(cd "$SCRIPTS_DIR/.." && pwd)"

# Onde os laboratórios ficam: ~/labs, fora do repositório do curso. Pode ser
# sobrescrito com a variável LABS_DIR.
LABS_DIR="${LABS_DIR:-$HOME/labs}"

# Nome de cada desafio, indexado pelo número.
LAB_NOMES=(
  "docker-funciona"
  "ola-container"
  "dentro-do-container"
  "ciclo-de-vida"
  "meu-primeiro-dockerfile"
  "instalando-dependencias"
  "camadas-e-cache"
  "o-que-nao-entra"
  "abrindo-portas"
  "configuracao-por-ambiente"
  "editando-ao-vivo"
  "dados-que-ficam"
  "site-estatico"
  "containers-conversando"
  "docker-compose"
  "faxina"
)

# Só os desafios 4 a 14 têm pasta em $LABS_DIR (os outros acontecem "no Docker
# inteiro": containers, imagens e volumes não moram em pasta nenhuma).
PRIMEIRO_LAB_COM_PASTA=4
ULTIMO_LAB_COM_PASTA=14

# Imagens-base usadas na aula. O setup.sh baixa todas antes, para a primeira
# execução de cada desafio não depender da rede.
IMAGENS_BASE=(hello-world alpine python:3.12-slim nginx:alpine)

# Tudo o que o curso cria no Docker, para o reset.sh e o desafio 15 saberem
# o que é "nosso".
CONTAINERS_DO_CURSO=(explorador relogio descartavel api cozinha dev web receitas)
IMAGENS_DO_CURSO=(receitas receitas-api receitas-web bloco)
VOLUMES_DO_CURSO=(notas)
REDES_DO_CURSO=(cozinha)

# ---------------------------------------------------------------------------
# Saída
# ---------------------------------------------------------------------------
if [[ -t 1 ]]; then
  C_VERDE=$'\e[32m'; C_VERM=$'\e[31m'; C_AMAR=$'\e[33m'; C_AZUL=$'\e[34m'
  C_NEG=$'\e[1m'; C_FIM=$'\e[0m'
else
  C_VERDE=""; C_VERM=""; C_AMAR=""; C_AZUL=""; C_NEG=""; C_FIM=""
fi

info()  { printf '%s\n' "${C_AZUL}▶${C_FIM} $*"; }
ok()    { printf '%s\n' "${C_VERDE}✅${C_FIM} $*"; }
aviso() { printf '%s\n' "${C_AMAR}⚠️ ${C_FIM} $*"; }
erro()  { printf '%s\n' "${C_VERM}❌${C_FIM} $*" >&2; }

# ---------------------------------------------------------------------------
# Números e caminhos dos desafios
# ---------------------------------------------------------------------------

# normalizar_num "5" | "05" | "05-nome"  ->  "05"
normalizar_num() {
  local n="${1%%-*}"
  [[ "$n" =~ ^[0-9]{1,2}$ ]] || return 1
  printf '%02d' "$((10#$n))"
}

lab_nome() { printf '%s' "${LAB_NOMES[$((10#$1))]:-}"; }
lab_dir()  { printf '%s/%s-%s' "$LABS_DIR" "$1" "$(lab_nome "$1")"; }

lab_tem_pasta() {
  local n=$((10#$1))
  (( n >= PRIMEIRO_LAB_COM_PASTA && n <= ULTIMO_LAB_COM_PASTA ))
}

# Descobre o desafio a partir do diretório atual (LABS_DIR/NN-nome/...).
detectar_lab() {
  local rel="${PWD#"$LABS_DIR"/}"
  [[ "$rel" != "$PWD" ]] || return 1
  local nn="${rel%%/*}"
  nn="${nn%%-*}"
  [[ "$nn" =~ ^[0-9]{2}$ ]] || return 1
  printf '%s' "$nn"
}

# resolver_lab [NN]  -> imprime "NN" a partir do argumento ou do diretório atual
resolver_lab() {
  local nn
  if [[ -n "${1:-}" ]]; then
    nn="$(normalizar_num "$1")" || { erro "Número de desafio inválido: '$1'. Use algo como 05."; return 1; }
  else
    nn="$(detectar_lab)" || {
      erro "Informe o número do desafio. Exemplo: $(basename "$0") 05"
      return 1
    }
  fi
  local n=$((10#$nn))
  if (( n < 0 || n > 15 )); then
    erro "O desafio $nn não existe. Use um número de 00 a 15."
    return 1
  fi
  printf '%s' "$nn"
}

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------

docker_ok() { docker info >/dev/null 2>&1; }

# Garante que o docker existe e que o daemon responde; explica o que fazer se não.
exigir_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    erro "O comando docker não está instalado."
    info "Num Codespace ele já vem. Em outra máquina: https://docs.docker.com/get-docker/"
    return 1
  fi
  if ! docker_ok; then
    erro "O Docker está instalado, mas o serviço (daemon) não respondeu."
    info "Num Codespace, espere um minuto depois de abrir e tente de novo."
    info "Em outra máquina: sudo systemctl start docker (ou abra o Docker Desktop)."
    return 1
  fi
}

container_existe()  { docker container inspect "$1" >/dev/null 2>&1; }
container_rodando() { [[ "$(docker container inspect -f '{{.State.Running}}' "$1" 2>/dev/null)" == "true" ]]; }
container_imagem()  { docker container inspect -f '{{.Config.Image}}' "$1" 2>/dev/null || true; }
container_cmd()     { docker container inspect -f '{{join .Config.Cmd " "}}' "$1" 2>/dev/null || true; }
container_env()     { docker container inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$1" 2>/dev/null | grep "^$2=" | head -1 | cut -d= -f2- || true; }
imagem_existe()     { docker image inspect "$1" >/dev/null 2>&1; }
imagem_id()         { docker image inspect -f '{{.Id}}' "$1" 2>/dev/null || true; }
imagem_env()        { docker image inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$1" 2>/dev/null | grep "^$2=" | head -1 | cut -d= -f2- || true; }
volume_existe()     { docker volume inspect "$1" >/dev/null 2>&1; }
rede_existe()       { docker network inspect "$1" >/dev/null 2>&1; }

# ids de todos os containers (parados ou não) criados a partir de uma imagem
containers_de() { docker ps -a --filter "ancestor=$1" -q 2>/dev/null || true; }

# porta do host ligada à porta $2 do container $1 (vazio se não publicada)
porta_publicada() { docker port "$1" "$2" 2>/dev/null | grep -oE '[0-9]+$' | head -1 || true; }

# lê um arquivo de dentro de um container, mesmo parado
ler_do_container() { docker cp "$1:$2" - 2>/dev/null | tar -xO 2>/dev/null || true; }

# GET simples; imprime o corpo (vazio se falhou). Insiste por alguns segundos:
# o uvicorn leva um instante para subir, e nesse meio-tempo a conexão pode ser
# recusada ou cair no meio, o que o --retry do curl não cobre.
http_get() {
  local tentativa corpo
  for tentativa in 1 2 3 4 5 6 7 8; do
    if corpo="$(curl -sf --max-time 5 "$1" 2>/dev/null)"; then
      printf '%s' "$corpo"
      return 0
    fi
    sleep 1
  done
  return 0
}

# Remoções silenciosas e idempotentes, para reset.sh
rm_container() { docker rm -f "$@" >/dev/null 2>&1 || true; }
rm_imagem()    { docker image rm -f "$@" >/dev/null 2>&1 || true; }
rm_volume()    { docker volume rm -f "$@" >/dev/null 2>&1 || true; }
rm_rede()      { docker network rm "$@" >/dev/null 2>&1 || true; }

# segundos entre .Created e .State.StartedAt de um container (0 se nunca reiniciou)
segundos_ate_ultimo_start() {
  local criado iniciado
  criado="$(docker container inspect -f '{{.Created}}' "$1" 2>/dev/null || true)"
  iniciado="$(docker container inspect -f '{{.State.StartedAt}}' "$1" 2>/dev/null || true)"
  [[ -n "$criado" && -n "$iniciado" ]] || { printf 0; return; }
  printf '%s' "$(( $(date -d "$iniciado" +%s) - $(date -d "$criado" +%s) ))"
}
