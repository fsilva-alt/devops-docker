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
$ cd ~/labs/16-containers-conversando
```

A API, com o Dockerfile completo, e um `cliente.py`, que busca `http://receitas:8000/receitas` e mostra o resultado. Nesse endereço, `receitas` é um nome, e não um endereço IP.
:::
:::card Para este exercício
`⏱ tempo`
: 6 min

`parte`
: Vários containers

`verificação`
: `check.sh 16`
:::
::::

<p class="eyebrow">Conceito · redes e DNS</p>

## Como um container encontra o outro?

<div class="netbox" data-label="rede cozinha"><div class="flow"><div class="node hi"><b>receitas</b><small>a API · escuta na 8000 · <strong>sem -p</strong></small></div><div class="arr back"><span class="a">←</span>http://receitas:8000/receitas</div><div class="node"><b>cliente</b><small>python:3.12-slim rodando cliente.py</small></div></div></div>

::::columns
:::card O papel do DNS
Um endereço **IP** é um número que identifica cada participante da rede. O **DNS** é um serviço que encontra esse número a partir de um nome. Nas redes que você cria, o Docker oferece DNS, e por isso o cliente pode usar `receitas` no endereço.

Na rede padrão, chamada `bridge`, essa busca por nome não funciona. O Compose cria uma rede com DNS para cada projeto, como a `10-api-com-compose_default` do exercício 10. Aqui, você mesmo cria a rede.
:::
:::card Quando usar -p?
O `-p` publica uma porta no Codespace. Entre containers da mesma rede, ele não é necessário, porque o cliente acessa direto a porta 8000 do container `receitas`.
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
| `docker network create <nome>` | cria uma rede em que os containers se encontram pelo nome |
| `docker run --network <rede> --name <n> …` | cria o container nessa rede, com esse nome |
| `docker network ls` | lista as redes existentes |
| `docker network inspect <rede>` | mostra os containers conectados e seus endereços IP |
| `docker network connect <rede> <container>` | conecta um container a mais uma rede |
| `docker network rm <rede>` | apaga a rede; só funciona sem containers conectados |

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

## O exercício

:::steps
1. Construa a API e crie a rede:

   ```console
   $ docker build -t receitas-api:1.6 .
   $ docker network create cozinha
   $ docker network ls
   ```

2. Inicie a API na rede `cozinha`, com o nome `receitas` e sem `-p`. O teste com `localhost:8000` falha, como esperado, porque a porta não foi publicada no Codespace:

   ```console
   $ docker run -d --name receitas --network cozinha receitas-api:1.6
   $ curl localhost:8000/receitas      # erro esperado: conexão recusada
   ```

3. Rode o cliente em outro container, na mesma rede. O `-v` compartilha a pasta onde está o `cliente.py`, como no exercício 11. A saída mostra as receitas que vieram da API:

   ```console
   $ docker run --rm --network cozinha -v "$PWD:/app" python:3.12-slim python /app/cliente.py
   ```

4. Veja quais containers estão conectados à rede. O cliente já terminou e foi removido pelo `--rm`, então só a API aparece:

   ```console
   $ docker network inspect cozinha
   ```
:::

:::card Verificação
```console
$ check.sh 16
```

A verificação inicia um container temporário na rede `cozinha` e testa o endereço da API a partir dele. Ela também percebe quando a API está sem porta publicada.
:::

:::note Use o nome esperado pelo cliente.
O endereço em `cliente.py` usa `receitas`, então o container da API precisa ter esse nome. Sem o `--name`, o Docker inventaria outro.
:::

:::card Missão extra
Rode o cliente **sem** `--network cozinha` e leia o erro: fora da rede, o nome `receitas` não existe. Compare `docker network inspect bridge` com `docker network inspect cozinha`.
:::
