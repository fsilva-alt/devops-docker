---
duration: 5
---

# Olá, container

{.lead}
Rodar um programa Python **dentro de um container**, sem instalar Python no Codespace, e ver a diferença entre a imagem e os containers criados a partir dela.

`docker run <imagem> <comando>` `docker ps` `docker ps -a` `docker images`

::::columns
:::card Onde fazer
No terminal do Codespace, em **qualquer pasta**. Quem cuida dos containers e das imagens é o Docker, então estes comandos não dependem da pasta em que você está.

Faça depois do exercício 0. Não é preciso preparar nenhum arquivo.
:::
:::card Para este exercício
`⏱ tempo`
: 5 min

`parte`
: Fundamentos

`verificação`
: `check.sh 01`
:::
::::

<p class="eyebrow">Conceito</p>

## Qual é a diferença entre imagem e container?

<div class="flow"><div class="node "><b>Registro</b><small>Docker Hub · onde as imagens ficam publicadas</small></div><div class="arr"><span class="a">→</span>docker pull · baixa a imagem</div><div class="node "><b>Imagem</b><small>programa e arquivos prontos para criar containers</small></div><div class="arr"><span class="a">→</span>docker run · cria e inicia</div><div class="node hi"><b>Container</b><small>ambiente criado a partir da imagem para executar o programa</small></div></div>

<div class="layers"><div class="cap">arquivos do container: base da imagem e alterações próprias</div><div class="stk"><div class="layer rw"><b>camada gravável</b><small>arquivos próprios do container · apagados ao removê-lo</small></div><div class="layer hi"><b>python:3.12-slim</b><small>Python 3.12 instalado</small></div><div class="layer "><b>debian:bookworm-slim</b><small>um Debian mínimo</small></div></div><div class="base">a imagem-base pode ser usada por vários containers</div></div>

:::card Como ler o comando
```text
$ docker run python:3.12-slim python -c 'print("Olá, Docker!")'
#          └── imagem ──────┘ └──── comando executado lá dentro ────┘
```

`python` é o nome da imagem, e `3.12-slim` é a **tag**, um rótulo que identifica uma versão ou variante. Se você não indicar a tag, o Docker usa `latest`.

Python é uma linguagem de programação. Aqui, a opção `-c` pede ao Python para executar o texto entre aspas, e `print` mostra a mensagem na tela.
:::

:::note docker run sempre cria um container novo.
Se você rodar o mesmo comando três vezes, terá três containers. Quando o programa termina, o container para, mas continua existindo até você removê-lo. `docker ps -a` mostra esses containers parados.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker run <imagem> [comando]` | cria um container novo e roda o comando (ou o padrão da imagem) |
| `docker ps` | containers rodando agora |
| `docker ps -a` | todos, inclusive os parados |
| `docker images` | imagens baixadas ou construídas nesta máquina |
| `docker pull <imagem>` | só baixa, sem rodar (o run faz isso sozinho na primeira vez) |
| `docker rm <container>` | remove um container parado (exercício 3) |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [O que é uma imagem?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-an-image/)<small>documentação oficial · em inglês</small>
- [O que é um container?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-container/)<small>documentação oficial · em inglês</small>
- [Onde as imagens são publicadas?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-registry/)<small>Docker Hub e outros registros · em inglês</small>
- [Comando · docker run](https://docs.docker.com/reference/cli/docker/container/run/)<small>-d, -it, --rm, --name, -p, -e, -v, --network</small>
- [Comando · docker ps](https://docs.docker.com/reference/cli/docker/container/ls/)<small>-a, --filter, --format</small>
- [Comando · docker images](https://docs.docker.com/reference/cli/docker/image/ls/)
- [Docker Hub · python](https://hub.docker.com/_/python)<small>tags: 3.12-slim, 3.12-alpine…</small>
:::

<p class="eyebrow">Tarefa · 5 min</p>

## O exercício

:::steps
1. Rode o `hello-world` de novo. A imagem já está no Codespace, então o Docker cria um container novo sem baixar nada, e mensagens de download como *Pulling* não aparecem:

   ```console
   $ docker run hello-world
   ```

2. Crie um container com Python. O trecho depois de `python:3.12-slim` é o comando que roda dentro dele. Mantenha as aspas simples por fora e as duplas na mensagem:

   ```console
   $ docker run python:3.12-slim python -c 'print("Olá, Docker!")'
   ```

3. Liste os containers. `docker ps` mostra só os que estão rodando, e agora não há nenhum, porque os dois programas já terminaram. Com `-a`, aparecem todos:

   ```console
   $ docker ps
   $ docker ps -a
   ```

4. Liste as imagens que estão no Codespace:

   ```console
   $ docker images
   ```
:::

:::card Verificação
```console
$ check.sh 01
```

Aprova quando existe um container do `hello-world` e um do `python:3.12-slim` que rodou um `print`.
:::

:::note Como ler a lista:
IMAGE é a imagem usada, COMMAND é o comando executado, STATUS é o estado atual e NAMES é o nome do container. `Exited (0)` quer dizer que o programa terminou sem erro. Como você não escolheu um nome, o Docker inventou um.
:::

:::card Missão extra
```console
$ docker run python:3.12-slim cat /etc/os-release
$ cat /etc/os-release
```

`cat` mostra o conteúdo de um arquivo, e `/etc/os-release` diz qual é a distribuição Linux. A do container pode ser diferente da do Codespace, mesmo que os dois usem o mesmo kernel.
:::
