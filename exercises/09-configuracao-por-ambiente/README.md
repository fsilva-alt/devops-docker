# Desafio 9 — Configuração por ambiente

⏱ 5 minutos · Módulo 3: Portas e configuração

## Objetivo

Configurar um container **sem reconstruir a imagem**: a mesma imagem, com valores diferentes, via variáveis de ambiente (`ENV` no Dockerfile, `-e` e `--env-file` no `docker run`).

## Onde

```bash
cd ~/labs/09-configuracao-por-ambiente
```

## Estado inicial

O `app.py` agora lê uma variável de ambiente:

```python
COZINHA = os.environ.get("COZINHA", "Cozinha sem nome")
```

e a rota `/` responde `{"mensagem": "Livro de receitas da <COZINHA>", ...}`. O `Dockerfile` está completo, mas não define a variável. Há também um `cozinha.env` para a missão extra.

## Três lugares para o mesmo valor

| Onde | Quando vale | Ganha de |
|---|---|---|
| Código: `os.environ.get("COZINHA", "Cozinha sem nome")` | Se ninguém definiu | — |
| `ENV COZINHA="..."` no Dockerfile | Padrão gravado na imagem | do código |
| `-e COZINHA="..."` ou `--env-file` no `docker run` | Só naquele container | da imagem |

A regra: **a imagem é a mesma em todo lugar; o que muda entre ambientes (nome, senha de banco, endereço de outro serviço) vem de fora.**

## Tarefa

1. Dê um padrão à imagem. No `Dockerfile`, antes do `EXPOSE`:

   ```dockerfile
   ENV COZINHA="Cozinha do Curso"
   ```

   ```bash
   docker build -t receitas-api:1.4 .
   docker run --rm receitas-api:1.4 env | grep COZINHA
   ```

2. Sobrescreva na hora de rodar, sem mexer na imagem:

   ```bash
   docker run -d --name cozinha -p 8002:8000 -e COZINHA="Cozinha da Ana" receitas-api:1.4
   curl localhost:8002/
   ```

3. Veja o que o container recebeu (o `exec` roda um comando dentro de um container que já está rodando):

   ```bash
   docker exec cozinha env | grep COZINHA
   ```

## Verificação

```bash
check.sh 09
```

Aprova quando a imagem tem um padrão e o container `cozinha` roda com um valor **diferente** do padrão, respondendo em `localhost:8002`.

## Dica

Não coloque segredos em `ENV` no Dockerfile: eles ficam gravados na imagem (lembra do `.env` no desafio 7?). Senhas entram por `-e` ou `--env-file`, na hora de rodar.

## Missão extra

Muitas variáveis cabem num arquivo. Veja o `cozinha.env` e use-o:

```bash
docker rm -f cozinha
docker run -d --name cozinha -p 8002:8000 --env-file cozinha.env receitas-api:1.4
curl localhost:8002/
```

A verificação reconhece a extra quando o container roda com a cozinha do arquivo.
