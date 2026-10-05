# Exercício 2 — Dentro do container

⏱ 5 minutos · Módulo 1: Fundamentos

## Objetivo

Por padrão, **um arquivo criado em um container não aparece em outro**, mesmo que os dois usem a mesma imagem. Para ver isso acontecer, você vai digitar comandos dentro de um container, criar um arquivo nele e depois procurá-lo em um container novo.

## Onde

Em qualquer pasta.

## Tarefa

1. Abra o Python em modo interativo, em que você digita uma instrução e recebe a resposta na hora. As opções `-i` e `-t`, usadas juntas como `-it`, permitem interagir pelo terminal. `--rm` remove o container quando o programa termina:

   ```bash
   docker run -it --rm python:3.12-slim
   ```

   Quando aparecer `>>>`, o Python estará esperando uma instrução. Digite `import platform; platform.platform()` e pressione Enter para ver informações do sistema. Depois, digite `exit()` para sair. De volta ao terminal do Codespace, execute `docker ps -a`. O container não aparece na lista, porque o `--rm` o removeu.

2. Agora abra o **Bash** dentro de outro container. O Bash é um **shell**, um programa que interpreta os comandos digitados no terminal. Desta vez, dê ao container o nome `explorador` e não use `--rm`:

   ```bash
   docker run -it --name explorador python:3.12-slim bash
   ```

   O texto antes do cursor, chamado **prompt**, muda para algo como `root@<id>:/#`. A partir daqui, os comandos são executados dentro do container. Execute um por vez:

   ```bash
   cat /etc/os-release
   ls /
   hostname
   python --version
   ```

   `cat` exibe o arquivo com informações do Linux; `ls /` lista as pastas e os arquivos da raiz do container; `hostname` mostra o nome do container na rede; e `python --version`, a versão do Python.

3. Ainda dentro do container, crie o arquivo `/marca.txt` e saia. `echo` produz o texto, e `>` o grava no arquivo indicado:

   ```bash
   echo "eu estive aqui" > /marca.txt
   exit
   ```

4. Agora, no terminal do Codespace, crie **outro** container da mesma imagem e tente ler o arquivo:

   ```bash
   docker run --rm python:3.12-slim cat /marca.txt
   ```

   A mensagem *No such file or directory* é esperada e significa que o arquivo não existe nesse container novo. O `/marca.txt` foi criado apenas no `explorador`, que aparece como parado em `docker ps -a`.

## Verificação

```bash
check.sh 02
```

A verificação avisa se o container do Python interativo não foi removido. Nesse caso, confira se você usou `--rm` na primeira etapa.

## Dicas

- Para sair de um container interativo sem encerrá-lo, pressione `Ctrl+P` e depois `Ctrl+Q`. No dia a dia, o mais comum é sair com `exit`.
- Para explorar os arquivos da imagem `python:3.12-slim` em um container temporário, use `docker run -it --rm python:3.12-slim bash`.

## Missão extra

O `explorador` está parado, mas ainda existe. Inicie esse mesmo container e confira se o arquivo continua nele:

```bash
docker start -ai explorador
cat /marca.txt
exit
```

`start -ai` inicia o container e liga o terminal a ele, para que você possa interagir. Parar um container preserva seus arquivos; removê-lo com `docker rm` apaga a camada de arquivos que pertence só a ele.
