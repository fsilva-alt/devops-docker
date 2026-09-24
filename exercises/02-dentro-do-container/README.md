# Desafio 2 — Dentro do container

⏱ 5 minutos · Módulo 1: Fundamentos

## Objetivo

Entrar num container de forma interativa, mexer no sistema de arquivos dele e comprovar que **cada container tem o seu próprio**: o que você cria num, o outro não vê.

## Onde

Em qualquer pasta.

## Tarefa

1. Um Python interativo dentro do container. O `-it` liga o teclado (`-i`) e o terminal (`-t`); o `--rm` apaga o container assim que ele terminar:

   ```bash
   docker run -it --rm python:3.12-slim
   ```

   No prompt `>>>`, experimente `import platform; platform.platform()` e saia com `exit()`. Depois, `docker ps -a`: nenhum container novo apareceu, por causa do `--rm`.

2. Agora um shell, num container **com nome**, sem `--rm`:

   ```bash
   docker run -it --name explorador python:3.12-slim bash
   ```

   Você está dentro do container (o prompt mudou para `root@<id>:/#`). Explore:

   ```bash
   cat /etc/os-release
   ls /
   hostname
   python --version
   ```

3. Deixe uma marca e saia:

   ```bash
   echo "eu estive aqui" > /marca.txt
   exit
   ```

4. Crie **outro** container da mesma imagem e procure a marca:

   ```bash
   docker run --rm python:3.12-slim cat /marca.txt
   ```

   *No such file or directory.* A imagem é a mesma, mas cada container tem a sua própria camada de arquivos. O `/marca.txt` existe só no `explorador`, que continua parado em `docker ps -a`.

## Verificação

```bash
check.sh 02
```

A verificação reclama se sobrarem containers do Python interativo sem nome (é sinal de que faltou o `--rm`).

## Dicas

- Para sair de um container interativo sem encerrá-lo: `Ctrl+P` e depois `Ctrl+Q`. Na prática, `exit` é o que você vai usar.
- `docker run -it --rm <imagem> bash` é o jeito mais rápido de "espiar" o que tem numa imagem.

## Missão extra

O `explorador` está parado, mas não morreu. Volte para dentro dele e confira que a marca continua lá:

```bash
docker start -ai explorador
cat /marca.txt
exit
```

`start -ai` religa o container **e** o seu terminal a ele. Os dados de um container só se perdem quando ele é removido (`docker rm`), não quando ele para.
