# Exercício 17 — Site e API com Compose

⏱ 6 minutos · Vários containers

## Objetivo

Agora o site e a API são iniciados juntos, pelo mesmo `compose.yaml`. No exercício 10, o arquivo tinha um serviço só. Aqui são dois: `api`, que entrega os dados, e `web`, que entrega o site. Com um único comando, o Compose constrói as duas imagens, cria uma rede para o projeto e inicia os dois containers nela, como você fez à mão no exercício 16.

## Onde

```bash
cd ~/labs/17-site-e-api-com-compose
```

## Estado inicial

Duas pastas, cada uma com o seu `Dockerfile`:

- `api/`: a API FastAPI, como no exercício 16.
- `web/`: o site do exercício 15, mais um `nginx.conf` que repassa tudo o que começa com `/api/` para `http://api:8000/`. O `app.js` agora busca `/api/receitas` em vez de um arquivo local.

O `compose.yaml` já vem com o serviço `api`. Como o `nginx.conf` procura a API pelo nome `api`, não mude o nome desse serviço. Na rede do projeto, cada serviço é encontrado pelo nome, como os containers do exercício 16.

## Tarefa

1. Rode `code compose.yaml` e acrescente o serviço `web` abaixo do `api`, alinhado com ele. O arquivo inteiro fica assim:

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

   Salve o arquivo. O `build` agora aponta para uma subpasta, porque cada serviço tem o seu `Dockerfile`. Só o `web` publica uma porta, porque o navegador fala com o nginx, e o nginx fala com a API pela rede do projeto. O `depends_on` faz o Compose iniciar o `api` antes do `web`, mas não garante que a API já esteja pronta para responder.

2. Inicie os dois serviços e veja o estado deles:

   ```bash
   docker compose up -d --build
   docker compose ps
   ```

3. Teste o site e a API pelo terminal. Se der erro logo no início, espere alguns segundos e tente de novo:

   ```bash
   curl localhost:8090/
   curl localhost:8090/api/receitas
   ```

   Depois, na aba **PORTS**, localize a porta 8090 e clique no ícone de globo. O navegador busca as receitas em `/api/receitas`, e o nginx encaminha esse pedido à API. A página mostra esse caminho junto da lista de receitas.

4. Veja os logs de um serviço e a rede que o Compose criou:

   ```bash
   docker compose logs api
   docker network ls
   ```

   A rede `17-site-e-api-com-compose_default` faz o papel da rede `cozinha` do exercício 16.

## Verificação

```bash
check.sh 17
```

Aprova quando os serviços `api` e `web` estão rodando e o site e a API respondem em `localhost:8090`.

## Dicas

- Os comandos do Compose precisam ser rodados **na pasta do `compose.yaml`**.
- Se o YAML tiver erro, `docker compose config` mostra a linha do problema. O `web:` precisa ficar alinhado com o `api:`.
- `docker compose down` para e remove os containers e a rede do projeto. As imagens ficam disponíveis; `docker compose up -d` cria e inicia os containers novamente usando essas imagens.

## Missão extra

Configure o nome da cozinha da API, como no exercício 10. No arquivo `compose.yaml`, acrescente `environment` abaixo de `build: ./api`, com o mesmo alinhamento. O início do arquivo fica assim. A parte do `web` não muda:

```yaml
services:
  api:
    build: ./api
    environment:
      COZINHA: "Cozinha do Compose"
```

Salve e rode `docker compose up -d` de novo. Só o container da API é recriado, porque só a configuração dele mudou. Confira o nome da cozinha com `curl localhost:8090/api/`.
