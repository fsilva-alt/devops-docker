# Desafio 14 — Docker Compose

⏱ 7 minutos · Módulo 5: Vários containers

## Objetivo

Descrever a API (Python) e o site (nginx) num único arquivo, `compose.yaml`, e subir os dois com **um comando**. O Compose cria a rede, constrói as imagens, dá nome aos containers e liga tudo.

## Onde

```bash
cd ~/labs/14-docker-compose
```

## Estado inicial

Duas pastas, cada uma com o seu `Dockerfile`:

- `api/`: a API FastAPI, como no desafio 13.
- `web/`: o site do desafio 12, mais um `nginx.conf` que repassa tudo o que começa com `/api/` para `http://api:8000/`. O `app.js` agora busca `/api/receitas` em vez de um arquivo local.

Repare no `nginx.conf`: `api` é o nome que o **serviço** vai ter no Compose. Nome de serviço é nome na rede, como no desafio anterior.

## Tarefa

1. Crie o arquivo `compose.yaml` (a indentação são dois espaços; YAML é sensível a isso):

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

   Cada chave em `services` vira um container. `build` diz onde está o Dockerfile; `ports` é o `-p`; `depends_on` só define a ordem de partida.

2. Suba tudo. O `--build` constrói (ou reconstrói) as imagens antes:

   ```bash
   docker compose up -d --build
   docker compose ps
   ```

3. O site fala com a API através do nginx. Pelo terminal e pelo navegador (aba **PORTS** → 8090). Na página, o texto diz de onde vieram as receitas: `/api/receitas`.

   ```bash
   curl localhost:8090/
   curl localhost:8090/api/receitas
   ```

4. Logs de um serviço:

   ```bash
   docker compose logs api
   ```

## Verificação

```bash
check.sh 14
```

## Dicas

- Os comandos do Compose precisam ser rodados **na pasta do `compose.yaml`**.
- `docker ps` mostra os containers com o prefixo da pasta (`14-docker-compose-api-1`): o Compose nomeia por você.
- Erro de YAML? `docker compose config` valida o arquivo e mostra a linha do problema.
- `docker compose down` para e remove containers e rede. As imagens ficam; `up -d` de novo é instantâneo.

## Missão extra

Configure a API pelo Compose, sem tocar em Dockerfile nenhum. No serviço `api`, acrescente:

```yaml
    environment:
      COZINHA: "Cozinha do Compose"
```

e rode `docker compose up -d` de novo. Só o `api` é recriado; `curl localhost:8090/api/` mostra o novo nome.
