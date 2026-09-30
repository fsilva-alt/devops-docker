#!/usr/bin/env bash
# Ponto de entrada do container de testes: sobe o daemon do Docker interno,
# espera ele responder e roda a suíte. Chamado por tests/rodar.sh.

set -euo pipefail

# O entrypoint da imagem dind aponta o cliente para tcp://docker:2375 (pensado
# para um container "docker" separado). Aqui o daemon é local: use o socket.
export DOCKER_HOST=unix:///var/run/docker.sock
# Definida e vazia: o dockerd-entrypoint.sh usa iptables-nft, como o Docker do
# Codespace. Qualquer valor não vazio (inclusive 0) escolheria o legacy.
export DOCKER_IPTABLES_LEGACY=
export CURSO_TESTE_ISOLADO=1

dockerd-entrypoint.sh >/var/log/dockerd.log 2>&1 &

for _ in $(seq 1 60); do
  docker info >/dev/null 2>&1 && break
  sleep 1
done
if ! docker info >/dev/null 2>&1; then
  echo "O daemon interno não subiu. Log:" >&2
  cat /var/log/dockerd.log >&2
  exit 1
fi

exec bash "$(dirname "${BASH_SOURCE[0]}")/solucoes.sh"
