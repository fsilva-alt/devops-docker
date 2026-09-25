# Desafio 8 — Abrindo portas

⏱ 5 minutos · Módulo 3: Portas e configuração

## Objetivo

Acessar, do navegador, uma API que roda **dentro** de um container: publicar a porta com `-p` e documentá-la com `EXPOSE`.

## Onde

```bash
cd ~/labs/08-abrindo-portas
```

## Estado inicial

A API do desafio anterior (`app.py`, `requirements.txt`, `.dockerignore`) e um `Dockerfile` pronto, na ordem certa, mas sem `EXPOSE`.

## Portas: dentro e fora

Uma **porta** é um número usado para direcionar conexões a um programa. Neste projeto, o uvicorn recebe pedidos na porta 8000 do container. Para acessar a API por uma porta do Codespace, usamos `-p 8001:8000`: pedidos enviados à porta 8001 do Codespace são encaminhados à porta 8000 do container.

```
navegador ──▶ Codespace:8001 ──▶ container:8000 (uvicorn)
                  ▲ fora              ▲ dentro
```

A ordem é sempre `-p <fora>:<dentro>`. `EXPOSE 8000` no Dockerfile **não** abre porta nenhuma: só documenta qual porta o programa usa, para quem for rodar a imagem.

## Tarefa

1. Acrescente ao `Dockerfile`, antes do `CMD`:

   ```dockerfile
   EXPOSE 8000
   ```

   e construa:

   ```bash
   docker build -t receitas-api:1.3 .
   ```

2. Rode em segundo plano, publicando a porta:

   ```bash
   docker run -d --name api -p 8001:8000 receitas-api:1.3
   ```

3. No terminal do Codespace, teste a API com `curl`, que acessa um endereço e mostra a resposta. Nesse terminal, `localhost` significa o próprio Codespace. O segundo comando mostra a ligação entre as portas:

   ```bash
   curl localhost:8001/receitas
   docker port api
   ```

   A resposta do `curl` deve conter a lista de receitas. Se a conexão for recusada logo após iniciar o container, espere alguns segundos e tente novamente.

4. Abra a aba **PORTS** (portas), ao lado de **TERMINAL**, na parte de baixo do VS Code. Localize a porta **8001**, passe o mouse sobre ela e clique no ícone de globo, **Open in Browser** (abrir no navegador). Use o endereço fornecido pelo Codespace; `localhost` no navegador do seu computador aponta para outra máquina. O acesso a esse endereço depende da configuração de visibilidade da porta.

   Acrescente `/docs` ao final do endereço aberto. Essa página, gerada pelo FastAPI, permite testar a API: expanda **GET /receitas**, clique em **Try it out** e depois em **Execute** para ver a resposta.

5. Cada pedido feito à API, chamado de **requisição**, aparece nos logs do uvicorn:

   ```bash
   docker logs api
   ```

## Verificação

```bash
check.sh 08
```

## Dicas

- *port is already allocated* significa que outro programa ou container já usa a porta 8001 do Codespace. Consulte `docker ps` para identificar qual é. A verificação deste desafio espera a porta 8001; libere-a antes de repetir o comando.
- O `app.py` escuta em `0.0.0.0`, não em `127.0.0.1`. Dentro do container, `127.0.0.1` é só o próprio container; um servidor preso nele nunca recebe conexões de fora, mesmo com `-p`.

## Missão extra

Inicie um segundo container da mesma imagem, usando outra porta do Codespace. Teste o acesso e depois remova esse segundo container:

```bash
docker run -d --name api2 -p 8005:8000 receitas-api:1.3
curl localhost:8005/receitas
docker rm -f api2
```
