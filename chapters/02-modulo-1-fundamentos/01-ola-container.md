---
duration: 5
---

# Olá, container

{.lead}
Executar um programa Python **dentro de um container** e comparar a imagem usada como base com os containers criados a partir dela.

`docker run <imagem> <comando>` `docker ps` `docker ps -a` `docker images`

::::columns
:::card Onde fazer
No terminal do Codespace, em **qualquer pasta**. Estes comandos usam recursos gerenciados pelo Docker e não dependem de arquivos da pasta atual.

Continue depois de concluir o desafio 0. Não é preciso preparar arquivos para este exercício.
:::
:::card Para este desafio
`⏱ tempo`
: 5 min

`módulo`
: Módulo 1 · Fundamentos

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
$ docker run python:3.12-slim python -c "print('Olá, Docker!')"
#          └── imagem ──────┘ └──── comando executado lá dentro ────┘
```

`python` é o nome da imagem; `3.12-slim` é a **tag**, um rótulo de versão ou variante. Sem tag, o Docker usa `latest`.

Python é uma linguagem de programação. Neste exemplo, `-c` pede que ela execute o texto entre aspas, e `print` mostra a mensagem na tela.
:::

:::note docker run sempre cria um container novo.
Rodou três vezes, três containers. Quando o comando termina, o container *para*, mas continua existindo (`docker ps -a`) até ser removido.
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
| `docker rm <container>` | remove um container parado (desafio 3) |

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

## O desafio

:::steps
1. Execute o teste novamente. Como a imagem já está disponível, não devem aparecer mensagens de download, como *Pulling*. O Docker cria um novo container:

   ```console
   $ docker run hello-world
   ```

2. Um container com Python dentro. O que vem depois da imagem é o comando a executar lá:

   ```console
   $ docker run python:3.12-slim python -c "print('Olá, Docker!')"
   ```

3. Liste os containers em execução e, depois, todos os containers. Os dois programas já terminaram, mas seus containers aparecem na segunda lista:

   ```console
   $ docker ps
   $ docker ps -a
   ```

4. Agora liste as imagens disponíveis:

   ```console
   $ docker images
   ```
:::

:::card Verificação
```console
$ check.sh 01
```

Aprova com um container do `hello-world` e um do `python:3.12-slim` rodando um `print`.
:::

:::note Como ler a lista:
IMAGE é a imagem; COMMAND, o comando; STATUS, o estado; e NAMES, o nome. `Exited (0)` significa que o programa terminou sem erro. Cada `docker run` acrescenta um container.
:::

:::card Missão extra
```console
$ docker run python:3.12-slim cat /etc/os-release
$ cat /etc/os-release
```

`cat` mostra o conteúdo do arquivo. Compare as distribuições Linux do container e do Codespace: seus arquivos podem ser diferentes, mesmo compartilhando o kernel.
:::
