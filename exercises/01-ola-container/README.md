# Exercício 1 — Olá, container

⏱ 5 minutos · Módulo 1: Fundamentos

## Objetivo

Rodar um programa Python dentro de um container, sem instalar Python no Codespace, e entender a diferença entre a imagem, que contém o programa e seus arquivos, e o container, criado a partir dela a cada `docker run`.

## Onde

Em qualquer pasta.

## Estado inicial

Você já executou `docker run hello-world` no exercício 0 e não precisa preparar nenhum arquivo.

## Tarefa

1. Execute o `hello-world` de novo. A imagem já está no Codespace, então o Docker cria um novo container sem baixar nada, e mensagens de download como *Pulling* não aparecem:

   ```bash
   docker run hello-world
   ```

2. Crie um container com Python, uma linguagem de programação. O trecho depois de `python:3.12-slim` é o comando que será executado dentro dele:

   ```bash
   docker run python:3.12-slim python -c 'print("Olá, Docker!")'
   ```

   `print("Olá, Docker!")` é uma instrução Python que mostra essa mensagem na tela, e a opção `-c` pede ao Python para executar esse texto. Quem executa é o Python que vem na imagem `python:3.12-slim`. Mantenha as **aspas simples por fora** e as duplas na mensagem. Com aspas simples, o Bash não interpreta o `!` como uma consulta ao histórico de comandos.

3. Onde foram parar esses containers? `docker ps` mostra só os que estão rodando, e agora não há nenhum, porque os dois já terminaram. Com `-a`, aparecem todos:

   ```bash
   docker ps
   docker ps -a
   ```

   Cada linha representa um container. **IMAGE** mostra a imagem usada; **COMMAND**, o comando executado; **STATUS**, o estado atual; e **NAMES**, o nome do container. `Exited (0)` indica que o programa terminou sem erro. Como você não escolheu um nome, o Docker gerou um automaticamente.

4. Liste as imagens disponíveis no Codespace:

   ```bash
   docker images
   ```

## Verificação

```bash
check.sh 01
```

## Dicas

- `docker run` **sempre cria um container novo**. Se você rodar o mesmo comando três vezes, terá três containers. Eles ficam parados, ocupando um pouco de disco, até você removê-los (exercício 3).
- Em `python:3.12-slim`, `python` é o nome e `3.12-slim` é a **tag**, um rótulo que identifica uma versão ou variante da imagem. Se você não indicar a tag, o Docker usa `latest`.

## Missão extra

Compare o sistema operacional de dentro e de fora do container:

```bash
docker run python:3.12-slim cat /etc/os-release
cat /etc/os-release
```

O comando `cat` mostra o conteúdo de um arquivo, e `/etc/os-release` informa qual é a distribuição Linux. Os arquivos e programas do container podem ser de uma distribuição diferente da do Codespace, mesmo que os dois compartilhem o mesmo núcleo do Linux, chamado **kernel**.
