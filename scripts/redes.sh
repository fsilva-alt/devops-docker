#!/usr/bin/env bash
# Ajuste de firewall carregado por lib.sh. O comando é rede.sh.
#
# Em alguns Codespaces, o Docker grava suas regras pelo iptables-nft, mas o
# iptables-legacy guarda regras de uma versão anterior do Docker, só para a
# docker0, com a política FORWARD DROP. As duas tabelas avaliam cada pacote:
# o legacy descarta o tráfego das redes criadas com docker network create ou
# pelo Compose (bridges br-*), e a conexão entre containers expira.
#
# O ajuste libera no legacy o tráfego das bridges br-*, de todas as redes,
# inclusive as criadas depois. Quem decide o que passa continua sendo o Docker,
# pelas regras no nft. As regras de firewall se perdem quando o Codespace é
# parado; por isso o ajuste roda na instalação, no check.sh e a cada terminal.

firewall_local() {
  if (( EUID == 0 )); then
    "$@"
  else
    sudo -n "$@"
  fi
}

tem_comando() { PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin" command -v "$1" >/dev/null 2>&1; }

# O firewall consultado é o desta máquina: só faz sentido com o daemon local.
docker_local() {
  local endpoint="${DOCKER_HOST:-}"
  if [[ -n "${DOCKER_CONTEXT:-}" || -z "$endpoint" ]]; then
    endpoint="$(docker context inspect -f '{{.Endpoints.docker.Host}}' "$(docker context show)" 2>/dev/null)" || return 1
  fi
  [[ "$endpoint" == unix://* ]]
}

# 0: conflito detectado; 1: não detectado; 2: não consegui consultar o firewall.
conflito_nft_legacy() {
  [[ "$(uname -s)" == Linux ]] || return 1
  tem_comando docker && docker_local || return 1
  tem_comando iptables-nft && tem_comando iptables-legacy || return 1
  local nft legacy
  nft="$(firewall_local iptables-nft -w 5 -S FORWARD 2>/dev/null)" || return 2
  legacy="$(firewall_local iptables-legacy -w 5 -S FORWARD 2>/dev/null)" || return 2
  # Docker atual no nft (DOCKER-FORWARD); no legacy, só a estrutura de uma versão
  # anterior. Se o Docker em uso gravar no legacy, nada é alterado.
  [[ "$nft" == *'-A FORWARD -j DOCKER-FORWARD'* &&
     "$legacy" == *'-P FORWARD DROP'* &&
     "$legacy" == *'-A FORWARD -j DOCKER-ISOLATION-STAGE-1'* &&
     "$legacy" != *'-A FORWARD -j DOCKER-FORWARD'* ]]
}

# regra_legacy <especificação>: insere no início de FORWARD, se ainda não existir
regra_legacy() {
  firewall_local iptables-legacy -w 5 -C FORWARD "$@" 2>/dev/null ||
    firewall_local iptables-legacy -w 5 -I FORWARD 1 "$@"
}

# 0: ajuste aplicado agora; 1: nada a fazer; 2: falhou.
ajustar_firewall_docker() {
  local estado=0
  conflito_nft_legacy || estado=$?
  (( estado == 0 )) || return "$estado"
  if firewall_local iptables-legacy -w 5 -C FORWARD -i br-+ -j ACCEPT 2>/dev/null &&
     firewall_local iptables-legacy -w 5 -C FORWARD -o br-+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null; then
    return 1
  fi
  # Respostas de conexões já aceitas e tudo o que sai de uma bridge br-*
  regra_legacy -o br-+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT || return 2
  regra_legacy -i br-+ -j ACCEPT || return 2
}
