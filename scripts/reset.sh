#!/usr/bin/env bash
# Recria o desafio NN no estado inicial, sem mexer nos demais.
# ATENÇÃO: apaga tudo o que você fez naquele desafio: a pasta dele e os
# containers, imagens, volumes e redes que ele pede para criar.
#
# Uso:
#   reset.sh 08          # recria o desafio 8
#   reset.sh             # dentro da pasta de um laboratório, detecta o desafio

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
source "$SCRIPTS_DIR/labs.sh"

nn="$(resolver_lab "${1:-}")" || exit 2
n=$((10#$nn))

if (( n == 0 )); then
  erro "O desafio 00 só confere se o Docker funciona; não há o que recriar."
  info "Para refazer, rode docker run hello-world e depois check.sh 00"
  exit 2
fi
if (( n == 15 )); then
  erro "O desafio 15 é a faxina do Docker inteiro; não há o que recriar."
  info "Para 'desfazer' a faxina, refaça os desafios que quiser: reset.sh NN e o enunciado."
  exit 2
fi

exigir_docker || exit 2

dentro=0
if lab_tem_pasta "$nn"; then
  dir="$(lab_dir "$nn")"
  # Se você estiver dentro da pasta que será apagada, precisará entrar novamente.
  atual="$(pwd -P)"
  destino="$(cd "$dir" 2>/dev/null && pwd -P)" || destino="$dir"
  [[ "$atual" == "$destino" || "$atual" == "$destino/"* ]] && dentro=1
  info "Recriando o desafio $nn em $dir (e limpando o que ele criou no Docker)..."
else
  info "Limpando o que o desafio $nn criou no Docker..."
fi

gerar_lab "$nn"
ok "Desafio $nn de volta ao estado inicial."
if (( dentro )); then
  aviso "Você estava dentro da pasta recriada. Rode: cd \"$dir\""
fi
