# Exercício 14 — Docker Compose

⏱ 7 minutos · Módulo 5: Vários containers

## Objetivo

O site e a API passam a ser configurados e iniciados juntos, com o **Docker Compose**. O arquivo `compose.yaml` descreve cada **serviço**, isto é, cada parte da aplicação. Aqui são dois: `api`, que fornece os dados, e `web`, que entrega o site. A partir desse arquivo, um único comando constrói as imagens, cria a rede e inicia os containers.

## Onde

```bash
cd ~/labs/14-docker-compose
```

## Estado inicial

Duas pastas, cada uma com o seu `Dockerfile`:

- `api/`: a API FastAPI, como no exercício 13.
- `web/`: o site do exercício 12, mais um `nginx.conf` que repassa tudo o que começa com `/api/` para `http://api:8000/`. O `app.js` agora busca `/api/receitas` em vez de um arquivo local.

Como o `nginx.conf` procura a API pelo nome `api`, o serviço da API precisa ter exatamente esse nome no Compose. Os serviços se encontram pelo nome na rede do projeto, assim como os containers do 13.

## Tarefa

1. Execute `code compose.yaml`, copie o conteúdo abaixo e salve. **YAML** é um formato de texto usado para configurações. Os espaços no início das linhas, chamados de **indentação**, indicam quais configurações pertencem a cada serviço. Mantenha os dois espaços por nível do exemplo e não use a tecla Tab:

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

   Neste exemplo, `api` e `web` são os dois serviços dentro de `services`. `build` indica a pasta do `Dockerfile`; `ports` publica portas, como `-p`; e `depends_on` faz o Compose iniciar `api` antes de `web`. Essa ordem não garante que a API já esteja pronta para responder.

2. Inicie os serviços. A opção `--build` constrói ou atualiza as imagens antes de iniciar os containers; `-d` mantém o terminal livre. O segundo comando mostra o estado dos serviços:

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

4. Consulte os logs de um serviço:

   ```bash
   docker compose logs api
   ```

## Verificação

```bash
check.sh 14
```

## Dicas

- Os comandos do Compose precisam ser rodados **na pasta do `compose.yaml`**.
- O Compose dá nome aos containers usando a pasta como prefixo. Em `docker ps`, o da API aparece como `14-docker-compose-api-1`.
- Erro de YAML? `docker compose config` valida o arquivo e mostra a linha do problema.
- `docker compose down` para e remove os containers e a rede do projeto. As imagens ficam disponíveis; `docker compose up -d` cria e inicia os containers novamente usando essas imagens.

## Missão extra

Configure o nome da cozinha pelo Compose. No arquivo `compose.yaml`, acrescente `environment` abaixo de `build: ./api`, com o mesmo alinhamento. O início do arquivo ficará assim; mantenha a seção `web` como está:

```yaml
services:
  api:
    build: ./api
    environment:
      COZINHA: "Cozinha do Compose"
```

Salve e execute `docker compose up -d` novamente. O container da API será recriado com a nova configuração. Use `curl localhost:8090/api/` para conferir o nome da cozinha.
