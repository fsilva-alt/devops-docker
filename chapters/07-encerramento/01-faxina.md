---
duration: 4
---

# Faxina

{.lead}
Ver quanto disco o Docker está usando e limpar o que você criou durante a aula. **Faça este exercício por último**, porque a limpeza remove containers e imagens que as verificações anteriores usam.

`docker system df` `docker stop $(docker ps -q)` `docker container prune` `docker image prune`

::::columns
:::card Onde fazer
No terminal do Codespace, em **qualquer pasta**. Quem cuida dos containers e das imagens é o Docker, então estes comandos não dependem da pasta em que você está.
:::
:::card Para este exercício
`⏱ tempo`
: 4 min · pode ficar para depois da aula

`parte`
: Encerramento

`verificação`
: `check.sh 18`
:::
::::

<p class="eyebrow">Conceito</p>

## O que está ocupando espaço?

| O quê | De onde veio |
| --- | --- |
| `containers parados` | continuam no disco até serem removidos, junto com seus arquivos e logs |
| `imagens <none> (dangling)` | versões antigas, que ficam sem nome quando você reconstrói uma imagem com a mesma tag |
| `cache de build` | etapas já construídas, que o Docker guarda para reaproveitar (exercício 6) |
| `volumes e redes` | o volume notas e a rede cozinha continuam existindo até você apagar |

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
: remove só as imagens sem nome; com -a, remove todas as que nenhum container usa

`docker volume prune`
: remove volumes anônimos sem uso; o volume nomeado notas é removido com docker volume rm notas

`docker network prune`
: remove redes sem uso, exceto as redes padrão

`docker system prune`
: remove containers parados, redes sem uso, imagens sem nome não usadas e cache de construção
:::

:::note Como ler docker system df:
SIZE é o espaço ocupado, e RECLAIMABLE é quanto dá para liberar. Os seus números vão ser diferentes dos do exemplo. Na limpeza, os containers parados saem primeiro, e depois as imagens que eles usavam.
:::

<p class="eyebrow">Referência</p>

## Comandos e próximos estudos

| Comando | Para quê |
| --- | --- |
| `docker system df` | mostra quanto disco cada categoria ocupa e quanto dá para liberar |
| `docker stop $(docker ps -q)` | para todos os containers que estão rodando |
| `docker container prune` | remove os containers parados |
| `docker image prune [-a]` | remove as imagens sem nome; com -a, todas as que nenhum container usa |
| `docker system prune -a --volumes` | faz uma limpeza mais ampla, que inclui imagens sem uso e volumes anônimos; pode apagar as imagens-base |
| `docker compose down [-v]` | para e remove os containers e a rede do projeto; com -v, também os volumes dele |

:::card O que estudar depois
- Publicar suas imagens no Docker Hub ou no GitHub Container Registry, com `docker push`.
- Deixar as imagens menores, com imagens-base enxutas e construções em várias etapas, os *multi-stage builds*.
- Rodar o programa com um usuário comum, sem os privilégios do `root`.
- Usar várias máquinas com o Kubernetes, que distribui containers entre vários computadores.
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
- [Repositório do curso](https://github.com/fsilva-alt/devops-docker)<small>enunciados, gabarito, guia do aluno</small>
:::

<p class="eyebrow">Tarefa · 4 min · pode ficar para depois da aula</p>

## O exercício

:::steps
1. Veja o espaço usado e a lista de containers:

   ```console
   $ docker system df
   $ docker ps -a
   ```

2. Pare tudo o que está rodando e remova os containers parados. O trecho `$(docker ps -q)` coloca no comando `stop` os IDs dos containers em execução. Se não houver nenhum, o `stop` avisa que falta um argumento, e você pode seguir para o `prune`. O `prune` pede confirmação, e você responde `y`:

   ```console
   $ docker stop $(docker ps -q)
   $ docker container prune
   ```

3. Remova as imagens sem nome, que são sobras dos builds:

   ```console
   $ docker image prune
   $ docker images
   ```

4. Veja o espaço usado de novo e compare com o da primeira etapa:

   ```console
   $ docker system df
   ```
:::

:::card Verificação
```console
$ check.sh 18
```

Aprova quando não há nenhum container, rodando ou parado, nem imagens `<none>`. A missão extra conta como feita quando não sobra nada do curso: volume, rede e imagens.
:::

:::note
**Para praticar de novo:** use `reset.sh NN`, trocando `NN` pelo número do exercício, e siga o enunciado desde o início. As verificações que dependem dos containers removidos só voltam a aprovar depois que você refizer o exercício.
:::

:::card Missão extra · volume, rede e imagens
```console
$ cd ~/labs/10-api-com-compose && docker compose down && cd -
$ cd ~/labs/17-site-e-api-com-compose && docker compose down && cd -
$ docker volume rm notas
$ docker network rm cozinha
$ docker images                 # confira as imagens restantes
$ docker image rm -f $(docker images -q 'receitas*' | sort -u) bloco:1.0
```

As duas primeiras linhas removem o que o Compose criou e voltam à pasta anterior. Se você fez os opcionais 12 e 14, faça o mesmo nas pastas deles. No 14, use `down -v` para apagar também o volume. Na última linha, `sort -u` tira os IDs repetidos, e `-f` permite remover imagens com mais de uma tag. Remover o volume `notas` apaga as notas guardadas nele.
:::

:::warning
**Ao terminar:** pare ou exclua o Codespace. Parado, ele ainda ocupa armazenamento da sua franquia. Se você excluir, perde os arquivos e as alterações que fez. O instalador recria só o material inicial do curso.
:::
