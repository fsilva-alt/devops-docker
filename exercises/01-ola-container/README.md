# Desafio 1 — Olá, container

⏱ 5 minutos · Módulo 1: Fundamentos

## Objetivo

Rodar um programa Python **dentro de um container** sem instalar nada, e ver a diferença entre **imagem** (o molde, baixado uma vez) e **container** (uma execução, criada a cada `docker run`).

## Onde

Em qualquer pasta.

## Estado inicial

Você já rodou `docker run hello-world` no desafio 0. Nada mais.

## Tarefa

1. Rode o `hello-world` de novo e repare no que **não** aparece desta vez: a linha *Unable to find image... Pulling*. A imagem já está aqui; o Docker só criou um container novo a partir dela:

   ```bash
   docker run hello-world
   ```

2. Agora um container de verdade, com Python dentro. O que vem depois do nome da imagem é o comando a executar lá dentro:

   ```bash
   docker run python:3.12-slim python -c "print('Olá, Docker!')"
   ```

   O `print` rodou num Python que **não é** o do Codespace: é o que vem na imagem `python:3.12-slim`.

3. Onde foram parar esses containers? `docker ps` mostra só os que estão rodando (nenhum: os dois já terminaram). Com `-a`, aparecem todos:

   ```bash
   docker ps
   docker ps -a
   ```

   Cada linha é um container: repare nas colunas IMAGE, COMMAND, STATUS (`Exited (0)`) e NAMES (um nome aleatório, porque você não escolheu um).

4. E as imagens, os moldes:

   ```bash
   docker images
   ```

## Verificação

```bash
check.sh 01
```

## Dicas

- `docker run` **sempre cria um container novo**. Rodou três vezes, três containers. Eles ficam parados, ocupando um pouco de disco, até você removê-los (desafio 3).
- Imagem `python:3.12-slim`: `python` é o nome, `3.12-slim` é a *tag* (a versão). Sem tag, o Docker assume `latest`.

## Missão extra

Compare o sistema operacional de dentro e de fora do container:

```bash
docker run python:3.12-slim cat /etc/os-release
cat /etc/os-release
```

Um é Debian, o outro é Ubuntu. Mesma máquina, dois "sistemas": é isso que um container faz.
