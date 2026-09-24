# Desafio 4 — Meu primeiro Dockerfile

⏱ 6 minutos · Módulo 2: Dockerfile

## Objetivo

Empacotar um programa seu numa **imagem**: escrever um `Dockerfile`, construir a imagem com `docker build` e rodá-la como qualquer outra.

## Onde

```bash
cd ~/labs/04-meu-primeiro-dockerfile
```

## Estado inicial

Um único arquivo, `receitas.py`, que imprime o livro de receitas. Veja com `cat receitas.py`.

## Dockerfile

Um `Dockerfile` é a receita da imagem: uma lista de instruções, uma por linha, executadas de cima para baixo.

| Instrução | O que faz |
|---|---|
| `FROM imagem` | Começa a partir de uma imagem existente (aqui, a que já tem Python) |
| `COPY origem destino` | Copia arquivos da sua pasta para dentro da imagem |
| `CMD ["prog", "arg"]` | O comando padrão quando alguém rodar `docker run` nesta imagem |

## Tarefa

1. Crie um arquivo chamado exatamente `Dockerfile` (D maiúsculo, sem extensão) com:

   ```dockerfile
   FROM python:3.12-slim

   COPY receitas.py /app/receitas.py

   CMD ["python", "/app/receitas.py"]
   ```

2. Construa a imagem. O `-t` dá nome e tag; o `.` no final é o **contexto**: a pasta cujos arquivos o `COPY` pode enxergar:

   ```bash
   docker build -t receitas:1.0 .
   ```

   Leia a saída: um passo por instrução (`[1/2] FROM`, `[2/2] COPY`).

3. A imagem existe:

   ```bash
   docker images receitas
   ```

4. Rode. Não é preciso dizer o comando: ele já está no `CMD`:

   ```bash
   docker run --rm receitas:1.0
   ```

## Verificação

```bash
check.sh 04
```

A verificação constrói nada: ela roda a sua imagem e confere que o livro de receitas aparece.

## Dicas

- Errou o Dockerfile? Corrija e rode o `docker build` de novo com o mesmo nome; a imagem é substituída.
- O `CMD` pode ser sobrescrito na hora: `docker run --rm receitas:1.0 python --version` ignora o `CMD` e roda o que você pediu.

## Missão extra

Uma imagem pode ter vários nomes. Crie a tag `latest` apontando para a mesma imagem e confira que o IMAGE ID é o mesmo:

```bash
docker tag receitas:1.0 receitas:latest
docker images receitas
docker run --rm receitas          # sem tag = latest
```
