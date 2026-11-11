---
duration: 6
---

# Persistência com Compose

{.lead}
Declarar um **volume nomeado no Compose**, gravar notas em containers temporários e conferir que elas continuam lá depois de `docker compose down`.

`volumes: notas:` `docker compose run --rm` `docker compose down` `docker compose down -v`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/14-compose-persistencia
```

`bloco.py` e um `Dockerfile` prontos, como no exercício 13. Cada texto passado ao programa vira uma nota em `/dados/notas.txt`. Sem texto, ele só mostra as notas guardadas. Só falta o `compose.yaml`.
:::
:::card Para este exercício
`⏱ tempo`
: 6 min · opcional, pode ficar para depois da aula

`parte`
: Dados

`verificação`
: `check.sh 14`
:::
::::

<p class="eyebrow">Conceito · o volume do exercício 13, em YAML</p>

## Volume nomeado no Compose

<div class="flow"><div class="node dim"><b>compose run --rm bloco</b><small>grava uma nota e o container é removido</small></div><div class="arr"><span class="a">→</span></div><div class="node hi"><b>volume 14-compose-persistencia_notas</b><small>/dados/notas.txt · fica depois do down</small></div><div class="arr"><span class="a">←</span></div><div class="node dim"><b>compose run --rm bloco</b><small>outro container lê as notas</small></div></div>

```yaml
services:
  bloco:
    build: .
    image: receitas-notas:1.0
    volumes:
      - notas:/dados

volumes:
  notas:
```

O primeiro `volumes`, dentro de `bloco`, **monta** o volume no container. O segundo, alinhado com `services`, **declara** o volume do projeto. `notas` é um nome, não um caminho de pasta.

| Comando | O que faz |
| --- | --- |
| `docker compose run --rm bloco "texto"` | cria um container para uma execução, como o `docker run --rm -v notas:/dados …` do exercício 13 |
| `docker compose down` | remove os containers e a rede, mas **mantém** os volumes nomeados |
| `docker compose down -v` | remove também os volumes, com as notas |

:::note O Compose usa a pasta como prefixo.
O volume se chama `14-compose-persistencia_notas`, e é esse o nome que aparece em `docker volume ls`.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker compose build` | constrói a imagem do serviço |
| `docker compose run --rm <serviço> [args]` | cria um container para uma execução e o remove ao terminar |
| `docker volume ls` | lista os volumes, inclusive os do Compose |
| `docker volume inspect <nome>` | detalhes de um volume |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Referência do arquivo Compose · volumes](https://docs.docker.com/reference/compose-file/volumes/)<small>volumes nomeados · em inglês</small>
- [Comando · docker compose run](https://docs.docker.com/reference/cli/docker/compose/run/)
- [Comando · docker compose down](https://docs.docker.com/reference/cli/docker/compose/down/)<small>-v, --rmi</small>
:::

<p class="eyebrow">Tarefa · 6 min · pode ficar para depois da aula</p>

## O exercício

:::steps
1. Rode `code compose.yaml`, copie o conteúdo do slide anterior e salve.

2. Confira o arquivo, construa a imagem e grave duas notas. A segunda execução mostra as duas:

   ```console
   $ docker compose config
   $ docker compose build
   $ docker compose run --rm bloco "comprar cenouras"
   $ docker compose run --rm bloco "assar o bolo"
   ```

3. Remova os containers e a rede do projeto e veja que o volume continua na lista:

   ```console
   $ docker compose down
   $ docker volume ls
   ```

4. Crie outro container só para ler as notas. `comprar cenouras` e `assar o bolo` continuam lá:

   ```console
   $ docker compose run --rm bloco
   ```
:::

:::card Verificação
```console
$ check.sh 14
```

Confere se o volume está declarado e se o serviço consegue ler as duas notas. Para recomeçar do zero, use `reset.sh 14`, entre de novo na pasta e repita a tarefa.
:::

:::card Missão extra
Depois da verificação, veja o que muda com o `-v`:

```console
$ docker compose down -v
$ docker compose run --rm bloco
```

O `-v` remove também o volume, com as notas. A última execução cria um volume novo e mostra `Nenhuma nota ainda.`. A verificação só volta a aprovar depois que você gravar as duas notas de novo.
:::
