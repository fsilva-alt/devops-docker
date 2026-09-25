# Desafio 2 — Dentro do container

⏱ 5 minutos · Módulo 1: Fundamentos

## Objetivo

Digitar comandos dentro de um container e criar um arquivo nele. Você vai observar que, por padrão, **um arquivo criado em um container não aparece em outro**, mesmo que os dois usem a mesma imagem.

## Onde

Em qualquer pasta.

## Tarefa

1. Abra o Python em modo interativo: você digita uma instrução e recebe a resposta na hora. As opções `-i` e `-t`, usadas juntas como `-it`, permitem interagir pelo terminal. `--rm` remove o container quando o programa termina:

   ```bash
   docker run -it --rm python:3.12-slim
   ```

   Quando aparecer `>>>`, o Python estará esperando uma instrução. Digite `import platform; platform.platform()` e pressione Enter para ver informações do sistema. Depois, digite `exit()` para sair. De volta ao terminal do Codespace, execute `docker ps -a`: esse container já foi removido por causa de `--rm`.

2. Abra o **Bash**, um programa que interpreta comandos de terminal, dentro de outro container. Esse tipo de programa é chamado de **shell**. Desta vez, dê ao container o nome `explorador` e não use `--rm`:

   ```bash
   docker run -it --name explorador python:3.12-slim bash
   ```

   A indicação antes do cursor, chamada **prompt**, muda para algo como `root@<id>:/#`. A partir daqui, os comandos são executados dentro do container. Execute um por vez:

   ```bash
   cat /etc/os-release
   ls /
   hostname
   python --version
   ```

   `cat` mostra o arquivo com informações do Linux; `ls /` lista as pastas e os arquivos na raiz do container; `hostname` mostra seu nome na rede; e `python --version` mostra a versão do Python.

3. Ainda dentro do container, crie o arquivo `/marca.txt` e saia. `echo` produz o texto, e `>` o grava no arquivo indicado:

   ```bash
   echo "eu estive aqui" > /marca.txt
   exit
   ```

4. Agora, no terminal do Codespace, crie **outro** container da mesma imagem e tente ler o arquivo:

   ```bash
   docker run --rm python:3.12-slim cat /marca.txt
   ```

   A mensagem *No such file or directory* significa que o arquivo não existe nesse novo container. Esse erro é esperado: `/marca.txt` foi criado apenas no `explorador`, que aparece como parado em `docker ps -a`.

## Verificação

```bash
check.sh 02
```

A verificação avisa se o container do Python interativo não foi removido. Nesse caso, confira se você usou `--rm` na primeira etapa.

## Dicas

- Para sair de um container interativo sem encerrá-lo: `Ctrl+P` e depois `Ctrl+Q`. Na prática, `exit` é o que você vai usar.
- `docker run -it --rm python:3.12-slim bash` permite explorar os arquivos dessa imagem em um container temporário.

## Missão extra

O `explorador` está parado, mas ainda existe. Inicie o mesmo container novamente e confira se o arquivo continua lá:

```bash
docker start -ai explorador
cat /marca.txt
exit
```

`start -ai` inicia o container e permite interagir com ele pelo terminal. Parar o container preserva seus arquivos; removê-lo com `docker rm` apaga a camada de arquivos própria dele.
