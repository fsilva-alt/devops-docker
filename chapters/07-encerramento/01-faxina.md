---
duration: 4
---

# Faxina

{.lead}
Consultar o espaço usado pelo Docker e remover recursos criados durante a aula. **Faça este desafio por último:** a limpeza remove containers e imagens usados nos exercícios anteriores.

`docker system df` `docker stop $(docker ps -q)` `docker container prune` `docker image prune`

::::columns
:::card Onde fazer
No terminal do Codespace, em **qualquer pasta**. Estes comandos usam recursos gerenciados pelo Docker e não dependem de arquivos da pasta atual.
:::
:::card Para este desafio
`⏱ tempo`
: 4 min · pode ficar para depois da aula

`módulo`
: Encerramento

`verificação`
: `check.sh 15`
:::
::::

<p class="eyebrow">Conceito</p>

## O que está ocupando espaço?

| O quê | De onde veio |
| --- | --- |
| `containers parados` | continuam no disco até serem removidos, junto com seus arquivos e logs |
| `imagens <none> (dangling)` | versões que podem ficar sem nome ao reconstruir uma imagem com a mesma tag |
| `cache de build` | resultados de etapas anteriores, reutilizados na construção (desafio 6) |
| `volumes e redes` | notas e cozinha continuam existindo até alguém apagar |

```console
$ docker system df
TYPE            TOTAL   ACTIVE   SIZE     RECLAIMABLE
Images          9       6        640MB    210MB (32%)
Containers      14      5        12MB     11MB (91%)
Local Volumes   1       1        4kB      0B (0%)
Build Cache     31      0        180MB    180MB
```

:::card Comandos de limpeza: prune
`docker container prune`
: remove todos os containers parados

`docker image prune`
: só as imagens sem nome; -a remove toda imagem sem container

`docker volume prune`
: remove volumes anônimos sem uso; o volume nomeado notas é removido com docker volume rm notas

`docker network prune`
: remove redes sem uso, exceto as redes padrão

`docker system prune`
: remove containers parados, redes sem uso, imagens sem nome não usadas e cache de construção
:::

:::note Como ler docker system df:
SIZE é o espaço ocupado; RECLAIMABLE é o que pode ser liberado. Os números do exemplo variam conforme o uso. Na limpeza, removemos primeiro os containers parados e depois as imagens que eles usavam.
:::

<p class="eyebrow">Referência</p>

## Comandos e próximos estudos

| Comando | Para quê |
| --- | --- |
| `docker system df` | quanto disco cada categoria ocupa e quanto é recuperável |
| `docker stop $(docker ps -q)` | para todos os que estão rodando |
| `docker container prune` | remove os parados |
| `docker image prune [-a]` | imagens sem nome \[ou todas sem container\] |
| `docker system prune -a --volumes` | amplia a limpeza para imagens sem uso e volumes anônimos sem uso; pode incluir as imagens-base |
| `docker compose down [-v]` | para e remove os recursos do projeto; -v inclui os volumes gerenciados pelo Compose |

:::card O que estudar depois
- **Compartilhar imagens:** publicar no Docker Hub ou no GitHub Container Registry com `docker push`.
- **Reduzir o tamanho das imagens:** estudar imagens-base menores e construções em múltiplas etapas, chamadas de *multi-stage builds*.
- **Definir permissões:** executar o programa com um usuário sem privilégios de administrador, em vez de `root`.
- **Usar várias máquinas:** conhecer o Kubernetes, que gerencia a execução de containers em vários computadores.
:::

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Comando · docker system df](https://docs.docker.com/reference/cli/docker/system/df/)
- [Comando · docker system prune](https://docs.docker.com/reference/cli/docker/system/prune/)<small>-a, --volumes</small>
- [Comando · docker container prune](https://docs.docker.com/reference/cli/docker/container/prune/)
- [Comando · docker image prune](https://docs.docker.com/reference/cli/docker/image/prune/)<small>-a</small>
- [Comando · docker compose down](https://docs.docker.com/reference/cli/docker/compose/down/)<small>-v, --rmi</small>
- [Onde as imagens são publicadas?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-registry/)<small>Docker Hub e outros registros · em inglês</small>
- [Descomplicando Docker (livro gratuito)](https://livro.descomplicandodocker.com.br/)<small>pt-br</small>
- [Repositório do curso](https://github.com/fsilva-alt/devops-docker)<small>enunciados, gabarito, guia do professor</small>
:::

<p class="eyebrow">Tarefa · 4 min · pode ficar para depois da aula</p>

## O desafio

:::steps
1. Consulte o espaço usado e a lista de containers:

   ```console
   $ docker system df
   $ docker ps -a
   ```

2. Pare os containers em execução e remova os parados. `$(docker ps -q)` insere a lista de IDs no comando `stop`. Se a lista estiver vazia, ele avisará que falta um argumento; nesse caso, siga para `prune`. Leia a confirmação e responda `y` para remover:

   ```console
   $ docker stop $(docker ps -q)
   $ docker container prune
   ```

3. As imagens sem nome, sobras dos builds:

   ```console
   $ docker image prune
   $ docker images
   ```

4. Consulte o espaço novamente e compare com a primeira etapa:

   ```console
   $ docker system df
   ```
:::

:::card Verificação
```console
$ check.sh 15
```

Aprova sem nenhum container (rodando ou parado) e sem imagens `<none>`. Extra: nada do curso sobrou (volume, rede, imagens).
:::

:::note
**Para praticar de novo:** use `reset.sh NN`, substituindo `NN` pelo número do desafio, e siga o enunciado desde o início. As verificações que dependem dos containers removidos deixam de aprovar até você refazê-los.
:::

:::card Missão extra · volume, rede e imagens
```console
$ cd ~/labs/14-docker-compose && docker compose down && cd -
$ docker volume rm notas
$ docker network rm cozinha
$ docker images                 # confira as imagens restantes
$ docker image rm -f $(docker images -q 'receitas*' | sort -u) bloco:1.0
```

A primeira linha remove os recursos do Compose e volta à pasta anterior. Na última, `sort -u` retira IDs repetidos, e `-f` permite remover imagens com mais de uma tag. A remoção do volume também apaga as notas.
:::

:::warning
**Ao terminar:** pare ou exclua o Codespace. Parado, ele ainda ocupa armazenamento. Excluído, perde os arquivos e alterações; o instalador recria apenas o material inicial do curso.
:::
