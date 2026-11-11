---
duration: 6
---

# Site e API com Compose

{.lead}
Acrescentar o site ao `compose.yaml` e iniciar o site e a API com **um comando**. O Docker Compose constrói as duas imagens, cria a rede do projeto e inicia os dois containers nela.

`services: api, web` `build: ./web` `depends_on` `docker compose up -d --build` `docker compose logs web`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/17-site-e-api-com-compose
```

Duas pastas, cada uma com o seu Dockerfile. `api/` tem a API. `web/` tem o site do exercício 15 e um `nginx.conf` que repassa para a API tudo o que começa com `/api/`. O `compose.yaml` já vem com o serviço `api`.
:::
:::card Para este exercício
`⏱ tempo`
: 6 min

`parte`
: Vários containers

`verificação`
: `check.sh 17`
:::
::::

<p class="eyebrow">Conceito</p>

## Dois serviços, uma rede

<div class="netbox" data-label="rede criada pelo Compose (17-site-e-api-com-compose_default)"><div class="flow"><div class="node"><b>navegador</b><small>endereço da porta 8090 na aba PORTS</small></div><div class="arr"><span class="a">→</span>ports: "8090:80"</div><div class="node hi"><b>web</b><small>nginx · entrega o site e encaminha os pedidos /api/</small></div><div class="arr"><span class="a">→</span>http://api:8000/</div><div class="node"><b>api</b><small>FastAPI + uvicorn · sem porta publicada</small></div></div></div>

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

No exercício 10, o arquivo tinha um serviço só. Agora são dois, cada um com a sua pasta e o seu Dockerfile. No arquivo, o `web:` fica alinhado com o `api:`.

| Configuração | O que faz |
| --- | --- |
| `build: ./web` | indica a pasta onde está o Dockerfile do site |
| `ports:` | só o web publica uma porta; o nginx fala com a API pela rede do projeto |
| `depends_on:` | inicia o api antes do web, mas não espera a API estar pronta para responder |

:::note Use o nome api.
O `nginx.conf` repassa para `http://api:8000` os pedidos que começam com `/api/`, então o serviço precisa se chamar `api`. Na rede do projeto, cada serviço é encontrado pelo nome, como os containers da rede `cozinha` no exercício 16.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker compose up -d --build` | constrói as imagens e inicia os dois serviços |
| `docker compose ps` | mostra os containers do projeto e o estado de cada um |
| `docker compose logs [-f] web` | mostra os logs do nginx; ajuda quando /api/ não responde |
| `docker compose down` | para e remove os containers e a rede do projeto |
| `docker network ls` | lista as redes, entre elas a que o Compose criou |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Referência do arquivo Compose · services](https://docs.docker.com/reference/compose-file/services/)<small>build, ports, depends_on · em inglês</small>
- [Redes no Compose](https://docs.docker.com/compose/how-tos/networking/)<small>a rede padrão do projeto · em inglês</small>
- [Como usar vários containers em uma aplicação](https://docs.docker.com/get-started/docker-concepts/running-containers/multi-container-applications/)<small>redes e Compose · em inglês</small>
:::

<p class="eyebrow">Tarefa · 6 min</p>

## O exercício

:::steps
1. Rode `code compose.yaml`, acrescente o serviço `web` como no slide anterior e salve. Confira os espaços no início de cada linha.

2. Inicie os dois serviços e veja o estado dos containers:

   ```console
   $ docker compose up -d --build
   $ docker compose ps
   ```

3. Teste o site e a API pelo terminal. Se der erro logo no início, espere alguns segundos e tente de novo. Depois, na aba **PORTS**, abra a porta **8090** pelo ícone de globo. A página mostra a lista de receitas e de onde ela veio, `/api/receitas`.

   ```console
   $ curl localhost:8090/
   $ curl localhost:8090/api/receitas
   ```

4. Veja os logs de um serviço e a rede que o Compose criou:

   ```console
   $ docker compose logs api
   $ docker network ls
   ```
:::

:::card Verificação
```console
$ check.sh 17
```

Aprova quando os serviços `api` e `web` estão rodando e o site e a API respondem na porta 8090.
:::

:::note Rode os comandos na pasta do compose.yaml.
Em `docker ps`, o container da API aparece como `17-site-e-api-com-compose-api-1`. Para parar e remover os containers e a rede do projeto, use `docker compose down`. As imagens continuam no Codespace para a próxima vez.
:::

:::card Missão extra
Acrescente `environment` ao serviço `api`, alinhado com `build`, como no exercício 10. O início do arquivo fica assim. A parte do `web` não muda:

```yaml
services:
  api:
    build: ./api
    environment:
      COZINHA: "Cozinha do Compose"
```

Salve e rode `docker compose up -d` de novo. Só o container da API é recriado. Confira o nome novo com `curl localhost:8090/api/`.
:::
