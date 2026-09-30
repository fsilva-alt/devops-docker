# Desafio 14 — Docker Compose

⏱ 7 minutos · Módulo 5: Vários containers

## Objetivo

Você vai usar o **Docker Compose** para configurar e iniciar o site e a API juntos. O arquivo `compose.yaml` descreve cada **serviço**, uma parte da aplicação: neste caso, `api` fornece os dados e `web` entrega o site. Com um comando, o Compose constrói as imagens, cria a rede e inicia os containers.

## Onde

```bash
cd ~/labs/14-docker-compose
```

## Estado inicial

Duas pastas, cada uma com o seu `Dockerfile`:

- `api/`: a API FastAPI, com um `HEALTHCHECK` pronto no Dockerfile. Ele testa `/receitas` dentro do container para verificar se o servidor está respondendo.
- `web/`: o site do desafio 12, mais um `nginx.conf` que repassa tudo o que começa com `/api/` para `http://api:8000/`. O `app.js` agora busca `/api/receitas` em vez de um arquivo local.

O `nginx.conf` já está configurado para procurar a API pelo nome `api`. Por isso, use exatamente esse nome no Compose. Os serviços podem se encontrar pelo nome na rede, como os containers do desafio anterior.

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
         api:
           condition: service_healthy
   ```

   Neste exemplo, `api` e `web` são os dois serviços dentro de `services`. `build` indica a pasta do `Dockerfile`; `ports` publica portas, como `-p`. `depends_on` com `condition: service_healthy` espera o teste de saúde da API passar antes de iniciar o site. Copie também as linhas `api:` e `condition:`: deixar `depends_on:` vazio não define essa dependência.

2. Valide o arquivo e inicie os serviços. A opção `--build` constrói ou atualiza as imagens antes de iniciar os containers; `-d` mantém o terminal livre. O último comando mostra o estado dos serviços; a API deve aparecer como **healthy** (saudável):

   ```bash
   docker compose config
   docker compose up -d --build
   docker compose ps
   ```

3. Teste o site e a API separadamente com os comandos abaixo. O primeiro deve retornar HTML; o segundo, uma lista em **JSON** contendo `Bolo de cenoura`. `--max-time 10` limita a espera, e `-f` sinaliza respostas HTTP de erro. Depois, na aba **PORTS**, abra a porta **8090** pelo ícone de globo. O navegador busca `/api/receitas` no mesmo endereço do site; o nginx encaminha esse pedido a `http://api:8000/receitas` pela rede Docker.

   ```bash
   curl --noproxy '*' -fsS --max-time 10 localhost:8090/
   curl --noproxy '*' -fsS --max-time 10 localhost:8090/api/receitas
   ```

4. Consulte os logs dos dois serviços para acompanhar o caminho do pedido:

   ```bash
   docker compose logs web api
   ```

## Verificação

```bash
check.sh 14
```

## Dicas

- Os comandos do Compose precisam ser rodados **na pasta do `compose.yaml`**.
- `docker ps` mostra os containers com o prefixo da pasta (`14-docker-compose-api-1`): o Compose nomeia por você.
- Erro de YAML? `docker compose config` valida o arquivo e mostra a linha do problema.
- `docker compose down` para e remove os containers e a rede do projeto. As imagens ficam disponíveis; `docker compose up -d` cria e inicia os containers novamente usando essas imagens.

## Se a página não carregar as receitas

O HTML aparecer em `curl localhost:8090/` só comprova que o nginx entrega a página. A lista depende de um segundo pedido a `/api/receitas`. **Healthy** comprova o teste interno da API; a comunicação do nginx até ela ainda precisa funcionar.

1. Confira a configuração e os logs:

   ```bash
   docker compose config
   docker compose ps
   docker compose logs --tail 30 web api
   ```

   Se a API estiver `unhealthy`, leia seus logs antes de continuar. Se o arquivo terminar em `depends_on:`, complete-o com o exemplo da tarefa e execute `docker compose up -d --build` novamente.

2. Faça um pedido **do container web para a API**, sem passar pelo navegador ou pelo encaminhamento `/api/`:

   ```bash
   docker compose exec web wget -T 5 -qO- http://api:8000/receitas
   ```

   - Se voltar a lista, a rede entre os serviços funciona. Confira `web/nginx.conf`: o destino deve ser `http://api:8000`, removendo `/api/` do caminho. Após editar esse arquivo, execute `docker compose up -d --build`.
   - Se aparecer erro ao resolver `api`, confira se o serviço se chama `api` e se os dois serviços usam a mesma rede.
   - Se der timeout mesmo com a API saudável, execute `check.sh 00` para testar a comunicação entre containers. Se esse teste passar, recrie a rede do projeto com `docker compose down` e `docker compose up -d --build`. Se falhar, pare e reabra o mesmo Codespace e repita a verificação.

3. Quando `curl --noproxy '*' -fsS --max-time 10 localhost:8090/api/receitas` retornar JSON, reabra a porta 8090 pela aba **PORTS** e recarregue a página. Use o endereço do site, não `http://api:8000` no navegador: o nome `api` é conhecido dentro da rede Docker.

O nginx consulta novamente o DNS do Docker para encontrar a API caso ela seja recriada e tenha outro IP. Os tempos de espera são limitados, e a página mostra o código HTTP em caso de erro, como `502` ou `504`, para ajudar a relacionar a falha aos logs.

Se você já tinha os laboratórios antigos, atualize o curso pelo instalador, guarde as alterações que quiser manter e use `reset.sh 14`. Entre novamente na pasta, crie o `compose.yaml` completo e refaça o build: isso atualiza o healthcheck, o nginx e o JavaScript.

## Missão extra

Configure o nome da cozinha pelo Compose. No arquivo `compose.yaml`, acrescente `environment` abaixo de `build: ./api`, com o mesmo alinhamento. O início do arquivo ficará assim; mantenha a seção `web` como está:

```yaml
services:
  api:
    build: ./api
    environment:
      COZINHA: "Cozinha do Compose"
```

Salve e execute `docker compose up -d` novamente. O container da API será recriado com a nova configuração. Consulte `curl localhost:8090/api/` para conferir o nome da cozinha.
