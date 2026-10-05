---
duration: 6
---

# Containers conversando

{.lead}
Fazer um container chamar outro **pelo nome**, numa rede criada por você, sem publicar porta nenhuma para fora.

`docker network create cozinha` `docker run --network cozinha` `http://receitas:8000` `docker network inspect`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/13-containers-conversando
```

A API (Dockerfile completo) e um `cliente.py`, que busca `http://receitas:8000/receitas` e imprime o resultado. `receitas` é um **nome**, não um IP.
:::
:::card Para este desafio
`⏱ tempo`
: 6 min

`módulo`
: Módulo 5 · Vários containers

`verificação`
: `check.sh 13`
:::
::::

<p class="eyebrow">Conceito · redes e DNS</p>

## Como um container encontra o outro?

<div class="netbox" data-label="rede cozinha"><div class="flow"><div class="node hi"><b>receitas</b><small>a API · escuta na 8000 · <strong>sem -p</strong></small></div><div class="arr back"><span class="a">←</span>http://receitas:8000/receitas</div><div class="node"><b>cliente</b><small>python:3.12-slim rodando cliente.py</small></div></div></div>

::::columns
:::card O papel do DNS
Um endereço **IP** identifica um participante da rede. O **DNS** encontra esse endereço a partir de um nome. Nas redes criadas por você, o Docker oferece esse serviço: o cliente pode usar `receitas` no endereço.

Na rede padrão `bridge`, essa busca automática por nome não está disponível.
:::
:::card Quando usar -p?
Use `-p` para publicar uma porta no Codespace. Entre containers da mesma rede, isso não é necessário: o cliente acessa a porta 8000 de `receitas` diretamente.
:::
:::card O cliente.py
```python
URL = "http://receitas:8000/receitas"
with urllib.request.urlopen(URL, timeout=5) as resposta:
    receitas = json.load(resposta)
```
:::
::::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker network create <nome>` | uma rede com DNS por nome de container |
| `docker run --network <rede> --name <n> …` | entra na rede com esse nome |
| `docker network ls` | lista as redes existentes |
| `docker network inspect <rede>` | mostra os containers conectados e seus endereços IP |
| `docker network connect <rede> <container>` | um container pode estar em várias redes |
| `docker network rm <rede>` | apaga (só sem containers conectados) |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Redes entre containers](https://docs.docker.com/engine/network/)<small>comunicação pelo nome em redes criadas por você · em inglês</small>
- [Redes do tipo bridge](https://docs.docker.com/engine/network/drivers/bridge/)<small>em inglês</small>
- [Comando · docker network create](https://docs.docker.com/reference/cli/docker/network/create/)
- [Como usar vários containers em uma aplicação](https://docs.docker.com/get-started/docker-concepts/running-containers/multi-container-applications/)<small>redes e Compose · em inglês</small>
- [Comando · docker run](https://docs.docker.com/reference/cli/docker/container/run/)<small>-d, -it, --rm, --name, -p, -e, -v, --network</small>
:::

<p class="eyebrow">Tarefa · 6 min</p>

## O desafio

:::steps
1. Construa a API e crie a rede:

   ```console
   $ docker build -t receitas-api:1.6 .
   $ docker network create cozinha
   $ docker network ls
   ```

2. Inicie a API com o nome `receitas` na rede `cozinha`, sem `-p`. O teste com `localhost:8000` deve falhar: não publicamos essa porta no Codespace.

   ```console
   $ docker run -d --name receitas --network cozinha receitas-api:1.6
   $ curl localhost:8000/receitas      # erro esperado: conexão recusada
   ```

3. Execute o cliente em outro container da mesma rede. `-v` compartilha a pasta com o arquivo `cliente.py`. A saída deve mostrar as receitas recebidas da API:

   ```console
   $ docker run --rm --network cozinha -v "$PWD:/app" python:3.12-slim python /app/cliente.py
   ```

4. Consulte os containers conectados. O cliente já terminou e foi removido por `--rm`; a API continua na rede:

   ```console
   $ docker network inspect cozinha
   ```
:::

:::card Verificação
```console
$ check.sh 13
```

Inicia um container temporário na rede `cozinha` e testa o endereço da API. Também identifica se ela está sem porta publicada.
:::

:::note Use o nome esperado pelo cliente.
O endereço em `cliente.py` usa `receitas`, então o container da API precisa desse nome. Sem `--name`, o Docker geraria outro nome automaticamente.
:::

:::card Missão extra
Rode o cliente **sem** `--network cozinha` e leia o erro: fora da rede, o nome `receitas` não existe. Compare `docker network inspect bridge` com `docker network inspect cozinha`.
:::
