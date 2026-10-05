#!/usr/bin/env bash
# Reproduz, só no Docker-in-Docker da suíte, o firewall de alguns Codespaces:
# Docker no iptables-nft e regras de uma versão anterior no legacy, com FORWARD DROP.
set -euo pipefail
[[ "${CURSO_TESTE_ISOLADO:-}" == 1 ]] || { printf 'Execute este teste com tests/rodar.sh.\n' >&2; exit 1; }
source "$HOME/devops-docker/scripts/lib.sh"
trap 'printf "Falha no teste de rede, linha %s: %s\n" "$LINENO" "$BASH_COMMAND" >&2' ERR

rede="curso-firewall-$RANDOM"
outra="$rede-outra"
servidor="$rede-servidor"
original="$(mktemp)"
iptables-legacy -S FORWARD >/dev/null   # a primeira consulta cria a tabela filter vazia
iptables-legacy-save > "$original"
limpar() {
  docker rm -f "$servidor" >/dev/null 2>&1 || true
  docker network rm "$outra" "$rede" >/dev/null 2>&1 || true
  iptables-legacy-restore < "$original"
  rm -f "$original"
}
trap limpar EXIT

# regras legacy|nft — as regras sem a data e os contadores de pacotes do *-save
regras() {
  "iptables-$1-save" | sed '/^#/d; s/\[[0-9]*:[0-9]*\]//'
}
probe() {
  docker run --rm --network "$1" python:3.12-slim python -u -c \
    "import socket; ip = socket.gethostbyname('$servidor'); print('DNS:', ip); s = socket.create_connection((ip, 8000), timeout=2); s.close()"
}
iniciar() {
  docker run -d --name "$servidor" --network "$rede" python:3.12-slim \
    python -m http.server 8000 --bind 0.0.0.0 >/dev/null
  for _ in {1..20}; do
    if docker exec "$servidor" python -c 'import socket; socket.create_connection(("127.0.0.1", 8000), timeout=1).close()' 2>/dev/null; then return 0; fi
    sleep 0.2
  done
  return 1
}
regras_do_curso() {
  local n=0
  iptables-legacy -C FORWARD -i br-+ -j ACCEPT 2>/dev/null && n=$((n + 1))
  iptables-legacy -C FORWARD -o br-+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null && n=$((n + 1))
  printf '%s' "$n"
}
tirar_regras_do_curso() {
  iptables-legacy -D FORWARD -i br-+ -j ACCEPT
  iptables-legacy -D FORWARD -o br-+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
}

docker network create "$rede" >/dev/null
iniciar
probe "$rede" >/dev/null
antes="$(regras legacy)"
rede.sh | grep -q 'Nenhum ajuste'
[[ "$antes" == "$(regras legacy)" ]]   # sem conflito, nada muda

# O que bloqueou os pacotes no Codespace: o nft aceita as bridges, mas uma cadeia
# de uma versão anterior do Docker no legacy termina na política FORWARD DROP.
iptables-legacy -N DOCKER-ISOLATION-STAGE-1
iptables-legacy -A DOCKER-ISOLATION-STAGE-1 -j RETURN
iptables-legacy -A FORWARD -j DOCKER-ISOLATION-STAGE-1
iptables-legacy -P FORWARD DROP
if saida="$(probe "$rede" 2>&1)"; then
  printf 'O teste não reproduziu o bloqueio do legacy.\n' >&2; exit 1
fi
[[ "$saida" == *'DNS:'* && "$saida" == *'TimeoutError'* ]]

# Se o Docker em uso gravasse no legacy (DOCKER-FORWARD lá), liberar br-+ furaria
# o isolamento dele: nada deve mudar.
iptables-legacy -N DOCKER-FORWARD
iptables-legacy -A FORWARD -j DOCKER-FORWARD
antes="$(regras legacy)"
rede.sh | grep -q 'Nenhum ajuste'
[[ "$antes" == "$(regras legacy)" ]]
iptables-legacy -D FORWARD -j DOCKER-FORWARD
iptables-legacy -X DOCKER-FORWARD

# check.sh aplica o ajuste sozinho; o teste de rede dele usa uma rede nova
saida="$(check.sh 00 2>&1)" || { printf '%s\n' "$saida" >&2; exit 1; }
[[ "$saida" == *'Firewall ajustado'* ]]
[[ "$(regras_do_curso)" == 2 ]]
probe "$rede" >/dev/null                # rede criada antes do ajuste

nft_antes="$(regras nft)"
antes="$(regras legacy)"
rede.sh | grep -q 'Nenhum ajuste'       # repetir não duplica
[[ "$antes" == "$(regras legacy)" && "$nft_antes" == "$(regras nft)" ]]
[[ "$(iptables-legacy -S FORWARD)" == *'-P FORWARD DROP'* ]]

docker network create "$outra" >/dev/null
docker network connect "$outra" "$servidor"
probe "$outra" >/dev/null               # rede criada depois do ajuste

# Codespace parado e reaberto: as regras do curso somem, as antigas voltam.
# Um terminal novo refaz o ajuste, só no Codespace.
tirar_regras_do_curso
if probe "$outra" >/dev/null 2>&1; then exit 1; fi
bash -ic true >/dev/null 2>&1
sleep 2
[[ "$(regras_do_curso)" == 0 ]]
CODESPACES=true bash -ic true >/dev/null 2>&1
for _ in {1..20}; do [[ "$(regras_do_curso)" == 2 ]] && break; sleep 0.5; done
[[ "$(regras_do_curso)" == 2 ]]
probe "$outra" >/dev/null
printf 'Firewall: bloqueio reproduzido; ajuste restrito ao cenário, sem duplicar, válido para redes novas e refeito em cada terminal.\n'
