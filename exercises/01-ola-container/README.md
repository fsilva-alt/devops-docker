# Desafio 1 — Olá, container

⏱ 5 minutos · Módulo 1: Fundamentos

## Objetivo

Executar um programa Python **dentro de um container**, sem instalar Python no Codespace. Você vai comparar a **imagem**, que contém o programa e seus arquivos, com o **container**, criado a partir dela a cada `docker run`.

## Onde

Em qualquer pasta.

## Estado inicial

Você já executou `docker run hello-world` no desafio 0. Não precisa preparar nenhum arquivo para este exercício.

## Tarefa

1. Execute o `hello-world` novamente. Como a imagem já está disponível, o Docker cria um novo container sem precisar baixá-la. Por isso, não devem aparecer mensagens de download, como *Pulling*:

   ```bash
   docker run hello-world
   ```

2. Crie um container com Python, uma linguagem de programação. O trecho depois de `python:3.12-slim` é o comando que será executado dentro dele:

   ```bash
   docker run python:3.12-slim python -c "print('Olá, Docker!')"
   ```

   `print('Olá, Docker!')` é uma instrução Python que mostra essa mensagem na tela. A opção `-c` pede ao Python para executar o texto entre aspas. Tudo isso acontece com o Python da imagem `python:3.12-slim`.

3. Onde foram parar esses containers? `docker ps` mostra só os que estão rodando (nenhum: os dois já terminaram). Com `-a`, aparecem todos:

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

- `docker run` **sempre cria um container novo**. Rodou três vezes, três containers. Eles ficam parados, ocupando um pouco de disco, até você removê-los (desafio 3).
- Em `python:3.12-slim`, `python` é o nome e `3.12-slim` é a **tag**, um rótulo que identifica uma versão ou variante da imagem. Sem uma tag, o Docker usa o rótulo `latest`.

## Missão extra

Compare o sistema operacional de dentro e de fora do container:

```bash
docker run python:3.12-slim cat /etc/os-release
cat /etc/os-release
```

O comando `cat` mostra o conteúdo de um arquivo. Nesse caso, `/etc/os-release` identifica a distribuição Linux. Compare a saída do container com a do Codespace: os arquivos e programas podem ser de distribuições diferentes, mesmo compartilhando o mesmo núcleo do Linux, chamado **kernel**.
