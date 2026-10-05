---
duration: 7
---

# Docker Compose

{.lead}
Configurar o site e a API no arquivo `compose.yaml` e iniciar os dois com **um comando**. O Docker Compose constrói as imagens, cria a rede e inicia os containers.

`compose.yaml` `docker compose up -d --build` `docker compose ps` `docker compose logs` `docker compose down`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/14-docker-compose
```

Duas pastas, cada uma com o seu Dockerfile: `api/` (a API FastAPI) e `web/` (o site do desafio 12 mais um `nginx.conf` que repassa `/api/` para `http://api:8000/`; o `app.js` agora busca `/api/receitas`).
:::
:::card Para este desafio
`⏱ tempo`
: 7 min

`módulo`
: Módulo 5 · Vários containers

`verificação`
: `check.sh 14`
:::
::::

<p class="eyebrow">Conceito</p>

## Um arquivo, todos os containers

<div class="netbox" data-label="rede criada pelo Compose (14-docker-compose_default)"><div class="flow"><div class="node"><b>navegador</b><small>endereço da porta 8090 na aba PORTS</small></div><div class="arr"><span class="a">→</span>ports: "8090:80"</div><div class="node hi"><b>web</b><small>nginx · entrega o site e encaminha os pedidos /api/</small></div><div class="arr"><span class="a">→</span>http://api:8000/</div><div class="node"><b>api</b><small>FastAPI + uvicorn · sem porta publicada</small></div></div></div>

```yaml
services:
  api:
    build: ./api

  web:
    build: ./web
    ports:
      - "8090:80"
    depends_on:
      - api
```

**YAML** é um formato de texto para configurações. Os espaços no início das linhas indicam a organização: use dois por nível, como no exemplo, sem Tab. `docker compose config` verifica se o arquivo é válido.

| Configuração | O que faz |
| --- | --- |
| `services:` | lista os serviços, as partes da aplicação. Aqui, api e web terão um container cada |
| `build: ./api` | indica a pasta que contém o Dockerfile da API |
| `ports:` | publica portas, como a opção -p de docker run |
| `depends_on:` | inicia api antes de web; não espera a API ficar pronta para responder |
| `environment:` | define variáveis de ambiente, como -e (missão extra) |

:::note Use o nome api.
O arquivo `nginx.conf` já encaminha pedidos que começam com `/api/` para `http://api:8000`. O Compose permite encontrar o serviço por esse nome na rede.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker compose up -d --build` | constrói as imagens e inicia os serviços em segundo plano |
| `docker compose ps` | os containers do projeto e o estado de cada um |
| `docker compose logs [-f] [serviço]` | logs de todos ou de um |
| `docker compose exec <serviço> <cmd>` | como o docker exec, pelo nome do serviço |
| `docker compose down` | para e remove containers e rede; -v remove volumes também |
| `docker compose config` | valida e mostra o arquivo interpretado |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Guia do Docker Compose](https://docs.docker.com/compose/)
- [Referência do arquivo Compose](https://docs.docker.com/reference/compose-file/)<small>services, build, ports, environment, volumes · em inglês</small>
- [Comando · docker compose up](https://docs.docker.com/reference/cli/docker/compose/up/)<small>-d, --build</small>
- [Comando · docker compose ps](https://docs.docker.com/reference/cli/docker/compose/ps/)
- [Comando · docker compose logs](https://docs.docker.com/reference/cli/docker/compose/logs/)
- [Comando · docker compose down](https://docs.docker.com/reference/cli/docker/compose/down/)<small>-v, --rmi</small>
- [Como usar vários containers em uma aplicação](https://docs.docker.com/get-started/docker-concepts/running-containers/multi-container-applications/)<small>redes e Compose · em inglês</small>
:::

<p class="eyebrow">Tarefa · 7 min</p>

## O desafio

:::steps
1. Execute `code compose.yaml`, copie o conteúdo do slide anterior e salve. Confira os espaços no início de cada linha.

2. Inicie os serviços. `--build` constrói as imagens antes, e `-d` deixa o terminal livre. Depois, consulte o estado dos containers:

   ```console
   $ docker compose up -d --build
   $ docker compose ps
   ```

3. Teste o site e a API no terminal. Na aba **PORTS**, abra a porta **8090** pelo ícone de globo. A página deve mostrar a lista de receitas e a origem `/api/receitas`. Se houver erro logo no início, espere alguns segundos e tente novamente.

   ```console
   $ curl localhost:8090/
   $ curl localhost:8090/api/receitas
   ```

4. Logs de um serviço:

   ```console
   $ docker compose logs api
   ```
:::

:::card Verificação
```console
$ check.sh 14
```

Confere os serviços `api` e `web` rodando e o site e a API respondendo na 8090.
:::

:::note Execute os comandos na pasta do compose.yaml.
O Compose cria nomes como `14-docker-compose-api-1`. Para parar e remover os containers e a rede do projeto, use `docker compose down`. As imagens ficam disponíveis para a próxima execução.
:::

:::card Missão extra
Acrescente `environment` ao serviço `api`, alinhado com `build`. O início do arquivo ficará assim; mantenha a seção `web`:

```yaml
services:
  api:
    build: ./api
    environment:
      COZINHA: "Cozinha do Compose"
```

Salve e execute `docker compose up -d` novamente. Consulte `curl localhost:8090/api/` para conferir o novo nome.
:::
