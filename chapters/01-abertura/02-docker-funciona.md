---
duration: 3
---

# Docker funciona?

{.lead}
Confirmar que o seu Codespace consegue **rodar containers**. Se algo estiver errado, é melhor descobrir com um dia de folga do que no meio da aula.

`docker version` `docker run hello-world` `docker compose version` `check.sh 00`

::::columns
:::card Onde fazer
No terminal do Codespace, em **qualquer pasta**. Estes comandos usam recursos gerenciados pelo Docker e não dependem de arquivos da pasta atual.
:::
:::card Para este desafio
`⏱ tempo`
: 3 min

`módulo`
: Abertura · feito antes da aula, logo depois do instalador

`verificação`
: `check.sh 00`
:::
::::

<p class="eyebrow">Conceito</p>

## O comando e o serviço do Docker

<div class="flow"><div class="node"><b>docker</b><small>o <strong>cliente</strong>: o comando que você digita</small></div><div class="arr"><span class="a">→</span>pede</div><div class="node hi"><b>dockerd</b><small>o <strong>daemon</strong>: serviço que recebe e executa os pedidos</small></div><div class="arr"><span class="a">→</span>administra</div><div class="node"><b>containers · imagens · volumes · redes</b><small>tudo o que a aula vai criar</small></div></div>

:::card A mensagem do primeiro container
```console
$ docker run hello-world
Hello from Docker!
To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image…
 4. The Docker daemon streamed that output to the Docker client…
```

O texto explica que o cliente fez um pedido, o serviço obteve a imagem, criou o container e mostrou a mensagem no terminal. Se a imagem já estiver disponível, não precisa ser baixada novamente.
:::

:::card Como saber se está funcionando
`docker version` mostra as seções **Client** (cliente) e **Server** (serviço). Se aparecer *Cannot connect to the Docker daemon*, o cliente não conseguiu acessar o serviço.

Em um Codespace recém-aberto, espere um minuto e tente novamente.
:::

:::note
**No modelo Blank**, o Docker e o Compose já vêm instalados. O instalador do curso confere o ambiente, baixa as imagens e prepara os arquivos dos exercícios.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker version` | mostra as versões do cliente e do serviço Docker |
| `docker info` | mostra informações do serviço: containers, imagens e armazenamento |
| `docker run hello-world` | cria e executa um container de teste; baixa a imagem se ela não estiver disponível |
| `docker compose version` | mostra a versão do Compose instalado |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Visão geral do Docker](https://docs.docker.com/get-started/docker-overview/)<small>documentação oficial · em inglês</small>
- [Docker Hub · hello-world](https://hub.docker.com/_/hello-world)
- [Comando · docker run](https://docs.docker.com/reference/cli/docker/container/run/)<small>-d, -it, --rm, --name, -p, -e, -v, --network</small>
- [Repositório do curso](https://github.com/fsilva-alt/devops-docker)<small>enunciados, gabarito, guia do professor</small>
:::

<p class="eyebrow">Tarefa · 3 min</p>

## O desafio

:::steps
1. Confira se aparecem as versões de **Client** e **Server**. Isso indica que o comando conseguiu acessar o serviço:

   ```console
   $ docker version
   ```

2. Execute o container de teste e procure a mensagem **Hello from Docker!**:

   ```console
   $ docker run hello-world
   ```

3. Confira a versão do Compose, a ferramenta que usaremos no desafio 14 para iniciar o site e a API juntos:

   ```console
   $ docker compose version
   ```
:::

:::card Verificação
```console
$ check.sh 00
```

Confere também que o instalador baixou as quatro imagens-base da aula (`hello-world`, `alpine`, `python:3.12-slim`, `nginx:alpine`). Faltou alguma? `setup.sh`.
:::

:::warning
**Depois, pare o Codespace** — em github.com/codespaces, ⋯ → *Stop codespace*, para não gastar a franquia. No dia da aula é só abrir de novo: imagens e laboratórios continuam lá.
:::

:::card Missão extra · opcional
Execute `docker info` para consultar um resumo do serviço Docker. Procure a linha `Containers:`: ela mostra o total de containers, incluindo os parados. O `hello-world` deve estar nessa contagem.
:::
