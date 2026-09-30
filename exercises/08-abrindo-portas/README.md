# Exercício 8 — Abrindo portas

⏱ 5 minutos · Módulo 3: Portas e configuração

## Objetivo

Acessar pelo navegador uma API que roda dentro de um container, publicando a porta com `-p` e documentando-a com `EXPOSE`.

## Onde

```bash
cd ~/labs/08-abrindo-portas
```

## Estado inicial

A API do exercício anterior (`app.py`, `requirements.txt`, `.dockerignore`) e um `Dockerfile` pronto, na ordem certa, mas sem `EXPOSE`.

## Portas: dentro e fora

Uma **porta** é um número usado para direcionar conexões a um programa. Neste projeto, o uvicorn recebe pedidos na porta 8000 do container. Para acessar a API por uma porta do Codespace, use `-p 8001:8000`. Assim, os pedidos enviados à porta 8001 do Codespace são encaminhados à porta 8000 do container.

```
navegador ──▶ Codespace:8001 ──▶ container:8000 (uvicorn)
                  ▲ fora              ▲ dentro
```

A ordem é sempre `-p <fora>:<dentro>`.

Já `EXPOSE 8000` serve principalmente como declaração e documentação. Essa instrução registra nos metadados da imagem a porta prevista para o programa, mas não inicia o servidor, não configura em qual endereço ele escuta e não publica a porta no Codespace. Por isso, `-p 8001:8000` funciona **mesmo sem `EXPOSE`**. Quem aproveita a declaração é a opção `docker run -P` (P maiúsculo), que publica as portas declaradas em portas escolhidas pelo Docker.

### Por que o servidor usa `0.0.0.0`?

`127.0.0.1` é o endereço de **loopback**, um caminho que leva de volta ao próprio ambiente de rede. Cada container deste curso tem o seu, separado do loopback do Codespace:

| Onde você faz o pedido | Para onde `127.0.0.1` ou `localhost` aponta |
|---|---|
| No terminal do Codespace | O próprio Codespace |
| Dentro do container `api` | O próprio container `api` |
| Dentro de outro container | Esse outro container, não a API |
| No navegador do seu computador | Seu computador, não o Codespace |

Se o uvicorn escutar só em `127.0.0.1:8000` dentro da API, ele aceitará apenas pedidos vindos daquele container, e publicar a porta com `-p` não muda isso. Por isso, `app.py` usa `host="0.0.0.0"`, que faz o servidor escutar em todas as interfaces IPv4 **do container**, inclusive a que recebe os pedidos de fora. `0.0.0.0` é uma configuração de escuta. Para acessar a API, use `localhost:8001` no terminal do Codespace ou o endereço da aba **PORTS** no navegador.

## Tarefa

1. Acrescente ao `Dockerfile`, antes do `CMD`:

   ```dockerfile
   EXPOSE 8000
   ```

   Essa linha documenta a porta; quem permite o acesso pelo Codespace é o `-p` da próxima etapa. Salve e construa:

   ```bash
   docker build -t receitas-api:1.3 .
   ```

2. Rode o container em segundo plano, publicando a porta:

   ```bash
   docker run -d --name api -p 8001:8000 receitas-api:1.3
   ```

3. No terminal do Codespace, teste a API com `curl`, que acessa um endereço e mostra a resposta. Nesse terminal, `localhost` é o próprio Codespace. O segundo comando mostra a ligação entre as portas:

   ```bash
   curl localhost:8001/receitas
   docker port api
   ```

   A resposta do `curl` deve conter a lista de receitas. Se a conexão for recusada logo após iniciar o container, espere alguns segundos e tente novamente.

4. Abra a aba **PORTS** (portas), ao lado de **TERMINAL**, na parte de baixo do VS Code. Localize a porta 8001, passe o mouse sobre ela e clique no ícone de globo, **Open in Browser** (abrir no navegador). Use o endereço fornecido pelo Codespace, porque `localhost` no navegador do seu computador aponta para o seu computador, não para o Codespace. O acesso a esse endereço depende da configuração de visibilidade da porta.

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

- *port is already allocated* significa que outro programa ou container já usa a porta 8001 do Codespace. Consulte `docker ps` para identificar qual é. A verificação espera a porta 8001, então libere-a antes de repetir o comando.
- Se a porta foi publicada, mas a API não responde, confira `docker logs api`: o servidor deve escutar em `0.0.0.0:8000`, como no código fornecido.

## Missão extra

Inicie um segundo container da mesma imagem, usando outra porta do Codespace. Teste o acesso e depois remova esse segundo container:

```bash
docker run -d --name api2 -p 8005:8000 receitas-api:1.3
curl localhost:8005/receitas
docker rm -f api2
```
