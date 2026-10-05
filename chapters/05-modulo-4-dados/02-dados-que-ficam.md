---
duration: 5
---

# Dados que ficam

{.lead}
Guardar notas em um **volume**, um espaço de armazenamento gerenciado pelo Docker. Assim, os dados permanecem mesmo depois de remover o container que os criou.

`docker volume create notas` `docker run -v notas:/dados` `docker volume ls` `docker volume inspect`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/11-dados-que-ficam
```

`bloco.py`: um bloco de notas que acrescenta cada nota a `/dados/notas.txt` e imprime todas. `Dockerfile` pronto, com `ENTRYPOINT` em vez de `CMD`.
:::
:::card Para este desafio
`⏱ tempo`
: 5 min · pode ficar para depois da aula

`módulo`
: Módulo 4 · Dados

`verificação`
: `check.sh 11`
:::
::::

<p class="eyebrow">Conceito</p>

## Onde os dados ficam guardados?

| Local | O que acontece com os arquivos |
| --- | --- |
| `camada gravável` | arquivos próprios do container; são apagados quando ele é removido |
| `bind mount -v /pasta/sua:/x` | arquivos da pasta do Codespace, compartilhados com o container |
| `volume -v nome:/x` | arquivos em um espaço gerenciado pelo Docker, mantido até você removê-lo |

<div class="flow"><div class="node dim"><b>container 1</b><small>grava uma nota e é removido por --rm</small></div><div class="arr"><span class="a">→</span></div><div class="node hi"><b>volume notas</b><small>/dados/notas.txt · fica</small></div><div class="arr"><span class="a">←</span></div><div class="node dim"><b>container 2</b><small>lê as notas, grava outra e é removido por --rm</small></div></div>

::::columns
:::card Volume
Uma pasta que o Docker guarda e administra. Você não precisa saber onde ela fica no disco; só o nome. Independente da imagem: qualquer container pode montá-la.
:::
:::card O que é um argumento?
É uma informação passada ao programa. Aqui, `ENTRYPOINT` define que o programa será `bloco.py`, e o texto depois da imagem, como `"comprar cenouras"`, é a nota a guardar.

Nos exemplos anteriores, com apenas `CMD`, um texto depois da imagem substituiria o comando inteiro.
:::
:::card Nome de volume ou caminho de pasta?
`-v notas:/dados` usa o volume chamado `notas`. `-v "$PWD:/dados"` compartilha a pasta atual. Nos dois casos, o programa acessa os arquivos pelo caminho `/dados` dentro do container.
:::
::::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker volume create <nome>` | cria um volume vazio (o -v também cria, se não existir) |
| `docker run -v <nome>:/pasta …` | monta o volume na pasta do container |
| `docker volume ls` | lista os volumes existentes |
| `docker volume inspect <nome>` | mostra detalhes do volume, incluindo seu local no disco |
| `docker volume rm <nome>` | apaga o volume e os dados; só se nenhum container o usa |
| `ENTRYPOINT ["prog"]` | o programa fixo; argumentos vêm do docker run |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Como guardar dados em volumes](https://docs.docker.com/get-started/docker-concepts/running-containers/persisting-container-data/)<small>em inglês</small>
- [Como usar volumes](https://docs.docker.com/engine/storage/volumes/)
- [Comando · docker volume create](https://docs.docker.com/reference/cli/docker/volume/create/)
- [Dockerfile · ENTRYPOINT](https://docs.docker.com/reference/dockerfile/#entrypoint)<small>e a diferença para CMD</small>
:::

<p class="eyebrow">Tarefa · 5 min · pode ficar para depois da aula</p>

## O desafio

:::steps
1. Construa a imagem e execute o bloco de notas duas vezes. A segunda execução mostra **apenas** "assar o bolo": a primeira nota estava no container removido por `--rm`.

   ```console
   $ docker build -t bloco:1.0 .
   $ docker run --rm bloco:1.0 "comprar cenouras"
   $ docker run --rm bloco:1.0 "assar o bolo"
   ```

2. Crie um volume e ligue-o à pasta `/dados` do container. Agora as duas notas aparecem: containers diferentes, mesmo volume.

   ```console
   $ docker volume create notas
   $ docker run --rm -v notas:/dados bloco:1.0 "comprar cenouras"
   $ docker run --rm -v notas:/dados bloco:1.0 "assar o bolo"
   ```

3. Execute sem passar uma nova nota para apenas ler as anteriores. Depois, liste os volumes e consulte os detalhes de `notas`:

   ```console
   $ docker run --rm -v notas:/dados bloco:1.0
   $ docker volume ls
   $ docker volume inspect notas
   ```
:::

::::columns
:::card Verificação
```console
$ check.sh 11
```

Lê o volume com outro container e espera pelo menos duas notas.
:::
:::card Missão extra
```console
$ docker run --rm -v notas:/dados alpine cat /dados/notas.txt
```

Leia as notas com outra imagem. Depois, `docker volume rm notas` apaga o volume e seu conteúdo. Para recomeçar, use `reset.sh 11`, entre novamente na pasta e repita o exercício.
:::
::::

:::warning
**Se faltar tempo:** você pode fazer este desafio depois da aula e seguir para o bloco de vários containers.
:::
