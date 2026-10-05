# Exercício 4 — Meu primeiro Dockerfile

⏱ 6 minutos · Módulo 2: Dockerfile

## Objetivo

Até aqui você usou imagens prontas. Agora vai criar a sua, com o programa de receitas fornecido pelo curso. Para isso, você escreve um `Dockerfile`, constrói a imagem com `docker build` e executa um container a partir dela.

## Onde

```bash
cd ~/labs/04-meu-primeiro-dockerfile
```

## Estado inicial

O arquivo `receitas.py` já está pronto. É um programa que mostra o livro de receitas no terminal, e você pode ler o código com `cat receitas.py`. Não é preciso escrever nem alterar nada nele.

## Dockerfile

Um `Dockerfile` é um arquivo de texto com as instruções para construir uma imagem, que o Docker lê de cima para baixo. Essa construção também é chamada de **build**.

| Instrução | O que faz |
|---|---|
| `FROM imagem` | Começa a partir de uma imagem existente (aqui, a que já tem Python) |
| `COPY origem destino` | Copia arquivos da sua pasta para dentro da imagem |
| `CMD ["prog", "arg"]` | O comando padrão quando alguém rodar `docker run` nesta imagem |

## Tarefa

1. Na pasta do exercício, execute `code Dockerfile` para abrir um novo arquivo no editor. O nome deve ser exatamente `Dockerfile`, com D maiúsculo e sem `.txt` no final. Copie o conteúdo abaixo para esse arquivo e salve:

   ```dockerfile
   FROM python:3.12-slim

   COPY receitas.py /app/receitas.py

   CMD ["python", "/app/receitas.py"]
   ```

2. Volte ao terminal e construa a imagem. A opção `-t` define o nome `receitas` e a tag `1.0`. O ponto `.` no final indica a pasta atual, chamada de **contexto de construção**. É nela que o Docker procura os arquivos usados pelo `COPY`:

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

A verificação usa a imagem que você construiu e confere se ela mostra o livro de receitas, então execute o `docker build` antes de rodar `check.sh`.

## Dicas

- Se precisar corrigir o `Dockerfile`, salve o arquivo e execute `docker build -t receitas:1.0 .` novamente. O nome `receitas:1.0` passará a apontar para a imagem atualizada.
- O `CMD` pode ser substituído na hora de rodar. Em `docker run --rm receitas:1.0 python --version`, o Docker ignora o `CMD` e executa o comando que você indicou.

## Missão extra

Uma imagem pode ter vários nomes. Crie a tag `latest` para a imagem `receitas:1.0` e confira que as duas linhas mostram o mesmo IMAGE ID:

```bash
docker tag receitas:1.0 receitas:latest
docker images receitas
docker run --rm receitas          # sem tag = latest
```
