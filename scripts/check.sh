#!/usr/bin/env bash
# Verifica se o desafio NN foi concluído e, se não, dá dicas.
#
# Uso:
#   check.sh 05          # verifica o desafio 5
#   check.sh             # dentro da pasta de um laboratório, detecta o desafio
#
# Sai com código 0 quando o desafio está concluído e 1 quando ainda não.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
source "$SCRIPTS_DIR/labs.sh"     # as verificações comparam com o conteúdo original
source "$SCRIPTS_DIR/checks.sh"

nn="$(resolver_lab "${1:-}")" || exit 2
n=$((10#$nn))

# O desafio 0 é justamente "o Docker funciona?": ele explica sozinho o que falta.
if (( n != 0 )); then
  exigir_docker || exit 2
fi

if lab_tem_pasta "$nn"; then
  dir="$(lab_dir "$nn")"
  if [[ ! -d "$dir" ]]; then
    erro "A pasta do desafio $nn não existe ($dir)."
    info "Gere com: setup.sh   (ou reset.sh $nn)"
    exit 2
  fi
  cd "$dir"
fi

"verificar_$nn"
relatorio "$nn"
