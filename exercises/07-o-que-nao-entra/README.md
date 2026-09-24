# Desafio 7 — O que não entra na imagem

⏱ 4 minutos · Módulo 2: Dockerfile · desafio elástico

## Objetivo

Impedir que lixo e segredos da sua pasta entrem na imagem com um `.dockerignore`. `COPY . .` copia **tudo** o que está no contexto, inclusive o que você não queria.

## Onde

```bash
cd ~/labs/07-o-que-nao-entra
```

## Estado inicial

Além de `app.py`, `requirements.txt` e um `Dockerfile` correto, a pasta tem o que costuma se acumular num projeto de verdade:

| O quê | Por que não deveria ir |
|---|---|
| `.venv/` (3 MB) | Ambiente virtual do Codespace; dentro do container o pip instala de novo, de forma limpa |
| `__pycache__/` | Cache do Python, gerado automaticamente |
| `.env` | Uma senha. Tudo o que entra na imagem pode ser lido por quem tiver a imagem |
| `notas-pessoais.md` | Anotações suas, não do projeto |
| `fotos/` (2 MB) | Não tem nada a ver com a API |

Veja com `ls -A` e `du -sh .venv fotos`.

## Tarefa

1. Construa e olhe o que foi parar dentro da imagem, senha inclusive:

   ```bash
   docker build -t receitas-api:1.2 .
   docker run --rm receitas-api:1.2 ls -A /app
   docker run --rm receitas-api:1.2 cat /app/.env
   ```

2. Crie o arquivo `.dockerignore`, um padrão por linha (a sintaxe é a mesma do `.gitignore`):

   ```
   .venv
   __pycache__
   .env
   notas-pessoais.md
   fotos
   ```

3. Construa de novo e confira: só o que interessa.

   ```bash
   docker build -t receitas-api:1.2 .
   docker run --rm receitas-api:1.2 ls -A /app
   ```

## Verificação

```bash
check.sh 07
```

## Dicas

- O `.dockerignore` vale para o **contexto** inteiro: o que está nele nem é enviado ao daemon, o que também deixa o build mais rápido.
- O primeiro build (com lixo) e o segundo (sem) têm tamanhos diferentes: `docker images receitas-api`.

## Missão extra

Inclua também `Dockerfile` e `.dockerignore` no `.dockerignore`: eles servem para construir a imagem, não precisam estar dentro dela. Construa e confira o `ls -A /app`.
