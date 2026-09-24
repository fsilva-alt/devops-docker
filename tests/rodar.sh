#!/usr/bin/env bash
# Roda a suíte de testes dentro de um container Docker-in-Docker isolado.
#
# Uso:  tests/rodar.sh
#
# Constrói a imagem de tests/Dockerfile (um Docker completo e vazio), monta este
# repositório em /workspaces/devops-docker (somente leitura) e executa
# tests/entrada.sh, que sobe o daemon e roda tests/solucoes.sh: o install.sh
# como um aluno faria e depois cada desafio nos três cenários (vazio, errado,
# certo), conferindo check.sh.
#
# Precisa de --privileged (o daemon interno cria namespaces e cgroups). O volume
# curso-docker-testes-cache guarda as imagens baixadas entre execuções.

set -euo pipefail
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGEM="curso-docker-testes"

docker build -q -t "$IMAGEM" -f "$RAIZ/tests/Dockerfile" "$RAIZ/tests" >/dev/null
docker run --rm -t --privileged \
  -v "$RAIZ:/workspaces/devops-docker:ro" \
  -v curso-docker-testes-cache:/var/lib/docker \
  "$IMAGEM" bash /workspaces/devops-docker/tests/entrada.sh
