# Desafio 4 — Meu primeiro Dockerfile

⏱ 6 minutos · Módulo 2: Dockerfile

## Objetivo

Criar uma **imagem** com o programa de receitas fornecido pelo curso. Você vai escrever um `Dockerfile`, construir a imagem com `docker build` e executar um container a partir dela.

## Onde

```bash
cd ~/labs/04-meu-primeiro-dockerfile
```

## Estado inicial

O arquivo `receitas.py` já está pronto e mostra o livro de receitas no terminal. Você pode ler seu conteúdo com `cat receitas.py`. Não precisa escrever nem alterar o programa neste desafio.

## Dockerfile

Um `Dockerfile` é um arquivo de texto com as instruções para construir uma imagem. O Docker lê essas instruções de cima para baixo. A construção da imagem também é chamada de **build**.

| Instrução | O que faz |
|---|---|
| `FROM imagem` | Começa a partir de uma imagem existente (aqui, a que já tem Python) |
| `COPY origem destino` | Copia arquivos da sua pasta para dentro da imagem |
| `CMD ["prog", "arg"]` | O comando padrão quando alguém rodar `docker run` nesta imagem |

## Tarefa

1. Na pasta do desafio, execute `code Dockerfile` para abrir um novo arquivo no editor. O nome deve ser exatamente `Dockerfile`, com D maiúsculo e sem `.txt` no final. Copie o conteúdo abaixo para esse arquivo e salve:

   ```dockerfile
   FROM python:3.12-slim

   COPY receitas.py /app/receitas.py

   CMD ["python", "/app/receitas.py"]
   ```

2. Volte ao terminal e construa a imagem. A opção `-t` define o nome `receitas` e a tag `1.0`. O ponto `.` no final indica a pasta atual, chamada de **contexto de construção**: é nela que o Docker procura os arquivos usados pelo `COPY`:

   ```bash
   docker build -t receitas:1.0 .
   ```

   Acompanhe as mensagens da construção. Você verá etapas como `FROM` e `COPY`; a numeração pode variar.

3. Confira se a imagem aparece na lista:

   ```bash
   docker images receitas
   ```

4. Execute um container com a imagem criada. Não é preciso informar o comando Python, porque ele já foi definido em `CMD`:

   ```bash
   docker run --rm receitas:1.0
   ```

## Verificação

```bash
check.sh 04
```

A verificação usa a imagem que você construiu e confere se ela mostra o livro de receitas. Por isso, execute o `docker build` antes de usar `check.sh`.

## Dicas

- Se precisar corrigir o `Dockerfile`, salve o arquivo e execute `docker build -t receitas:1.0 .` novamente. O nome `receitas:1.0` passará a apontar para a imagem atualizada.
- O `CMD` pode ser sobrescrito na hora: `docker run --rm receitas:1.0 python --version` ignora o `CMD` e roda o que você pediu.

## Missão extra

Uma imagem pode ter vários nomes. Crie a tag `latest` apontando para a mesma imagem e confira que o IMAGE ID é o mesmo:

```bash
docker tag receitas:1.0 receitas:latest
docker images receitas
docker run --rm receitas          # sem tag = latest
```
