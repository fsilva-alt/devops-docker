#!/usr/bin/env bash
# Corrige o firewall quando containers não conseguem conversar pela rede em
# alguns Codespaces (explicação em redes.sh). A instalação, o check.sh e cada
# terminal novo no Codespace já fazem isso; use à mão se aparecer timeout.
#
# Uso: rede.sh

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

estado=0
ajustar_firewall_docker || estado=$?
case "$estado" in
  0) ok "Firewall ajustado: os containers já podem conversar pelas redes Docker." ;;
  1) info "Nenhum ajuste de firewall necessário." ;;
  *) erro "Não consegui ajustar o firewall. Confira a saída de: sudo iptables-legacy -S FORWARD"; exit 1 ;;
esac
