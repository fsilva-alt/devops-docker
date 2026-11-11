---
duration: 5
---

# Dados que ficam

{.lead}
Guardar notas em um **volume**, um espaço de armazenamento gerenciado pelo Docker, para que elas continuem existindo depois que o container que as criou for removido.

`docker volume create notas` `docker run -v notas:/dados` `docker volume ls` `docker volume inspect`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/13-dados-que-ficam
```

`bloco.py` é um bloco de notas: acrescenta cada nota a `/dados/notas.txt` e mostra todas. O `Dockerfile` já está pronto, com `ENTRYPOINT` no lugar de `CMD`.
:::
:::card Para este exercício
`⏱ tempo`
: 5 min · pode ficar para depois da aula

`parte`
: Dados

`verificação`
: `check.sh 13`
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
É uma pasta que o Docker administra. Para usar, você só precisa do nome, sem saber onde ela fica no disco. O volume não depende da imagem, então qualquer container pode usá-lo.
:::
:::card O que é um argumento?
É uma informação passada ao programa. Aqui, o `ENTRYPOINT` define que o programa é o `bloco.py`, e o texto depois da imagem, como `"comprar cenouras"`, é a nota a guardar.

Nas imagens anteriores, que só tinham `CMD`, um texto depois da imagem substituiria o comando inteiro.
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
| `docker volume rm <nome>` | apaga o volume e os dados; só funciona se nenhum container estiver usando |
| `ENTRYPOINT ["prog"]` | define o programa da imagem; os argumentos vêm do docker run |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Como guardar dados em volumes](https://docs.docker.com/get-started/docker-concepts/running-containers/persisting-container-data/)<small>em inglês</small>
- [Como usar volumes](https://docs.docker.com/engine/storage/volumes/)
- [Comando · docker volume create](https://docs.docker.com/reference/cli/docker/volume/create/)
- [Dockerfile · ENTRYPOINT](https://docs.docker.com/reference/dockerfile/#entrypoint)<small>e a diferença para CMD</small>
:::

<p class="eyebrow">Tarefa · 5 min · pode ficar para depois da aula</p>

## O exercício

:::steps
1. Construa a imagem e use o bloco de notas duas vezes. A segunda vez mostra só "assar o bolo", porque a primeira nota estava no container que o `--rm` removeu.

   ```console
   $ docker build -t bloco:1.0 .
   $ docker run --rm bloco:1.0 "comprar cenouras"
   $ docker run --rm bloco:1.0 "assar o bolo"
   ```

2. Crie um volume e ligue-o à pasta `/dados` do container. Agora as duas notas aparecem, porque os containers são diferentes, mas o volume é o mesmo.

   ```console
   $ docker volume create notas
   $ docker run --rm -v notas:/dados bloco:1.0 "comprar cenouras"
   $ docker run --rm -v notas:/dados bloco:1.0 "assar o bolo"
   ```

3. Rode o programa sem passar uma nota. Ele só mostra as que já estão guardadas. Depois, liste os volumes e veja os detalhes de `notas`:

   ```console
   $ docker run --rm -v notas:/dados bloco:1.0
   $ docker volume ls
   $ docker volume inspect notas
   ```
:::

::::columns
:::card Verificação
```console
$ check.sh 13
```

A verificação lê o volume com outro container e espera encontrar pelo menos duas notas.
:::
:::card Missão extra
```console
$ docker run --rm -v notas:/dados alpine cat /dados/notas.txt
```

O volume não depende da imagem, então dá para ler as notas com outra, como a `alpine`. Depois, `docker volume rm notas` apaga o volume e as notas guardadas nele. Para refazer o exercício, use `reset.sh 13`, entre de novo na pasta e repita as etapas.
:::
::::

:::warning
**Se faltar tempo:** deixe este exercício para depois da aula e siga para o 15.
:::
