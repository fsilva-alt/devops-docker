# Exercício 15 — Faxina

⏱ 4 minutos · Encerramento · **Opcional**

Pode ser feita depois da aula. Mesmo que você adie a limpeza, pare ou exclua o Codespace ao encerrar a sessão.

**Faça a faxina por último**, depois de todos os exercícios que quiser praticar, inclusive os opcionais 16 e 17. Ela remove recursos que as verificações anteriores usam.

## Objetivo

Descobrir quanto disco o Docker está usando e limpar o que você criou ao longo do curso: containers parados, imagens sem nome, redes e volumes.

## Onde

Em qualquer pasta.

## O que está ocupando espaço?

Os containers criados sem `--rm` continuam existindo até serem removidos, mesmo depois que o programa termina. Reconstruir uma imagem com a mesma tag também pode deixar a versão anterior sem nome, identificada como `<none>` ou *dangling*. O comando `docker system df` mostra o espaço usado por categoria. A coluna **RECLAIMABLE** indica o espaço que pode ser liberado.

## Tarefa

1. Consulte o uso de espaço e a lista de containers:

   ```bash
   docker system df
   docker ps -a
   ```

2. Pare tudo o que está rodando e remova os parados. O `prune` pede confirmação (`y`):

   ```bash
   docker stop $(docker ps -q)
   docker container prune
   ```

   O trecho `$(docker ps -q)` executa primeiro `docker ps -q` e insere os IDs encontrados no comando `docker stop`. Se não houver containers rodando, `stop` avisará que falta um argumento. Nesse caso, siga para `docker container prune`.

3. Remova as imagens sem nome, sobras dos builds:

   ```bash
   docker image prune
   docker images
   ```

4. Consulte o uso de espaço novamente e compare com o resultado da primeira etapa:

   ```bash
   docker system df
   ```

## Verificação

```bash
check.sh 15
```

Aprova sem nenhum container (rodando ou parado) e sem imagens `<none>`.

## Dicas

- Depois da limpeza, as verificações dos exercícios que dependem dos containers removidos deixam de aprovar. Para praticar novamente, use `reset.sh NN`, substituindo `NN` pelo número, e siga o enunciado desde o início.
- `docker container prune` remove containers parados. Já `docker image prune` remove imagens sem nome que não são usadas por nenhum container, mesmo parado. Por isso, os containers saem primeiro, e as imagens depois.

## Missão extra

Apague também o que tem nome: o volume, a rede e as imagens do curso. A verificação reconhece a missão extra quando nada do curso sobrou.

Se você fez os opcionais de Compose, remova também os recursos deles. Execute apenas as linhas dos projetos que você criou; `-v` apaga as notas do exercício 17:

```bash
docker compose -f ~/labs/16-compose-desenvolvimento/compose.yaml down
docker compose -f ~/labs/17-compose-persistencia/compose.yaml down -v
```

```bash
cd ~/labs/14-docker-compose && docker compose down && cd -
docker volume rm notas
docker network rm cozinha
docker images                                   # veja o que sobrou com nome
docker image rm -f $(docker images -q 'receitas*' | sort -u) bloco:1.0
```

Na primeira linha, `&&` executa cada comando somente se o anterior funcionar; `cd -` volta à pasta anterior. Na última, `docker images -q 'receitas*'` lista os IDs das imagens de receitas, e `sort -u` retira os IDs repetidos. O `-f` permite remover imagens com mais de uma tag, como `receitas:1.0` e `receitas:latest`.

Para uma limpeza mais ampla, `docker system prune -a --volumes` remove containers parados, redes sem uso, imagens não usadas por containers, cache de construção e volumes anônimos sem uso. Isso pode incluir as imagens-base da aula, mas não remove volumes nomeados como `notas`. Leia o aviso antes de responder `y`. Se precisar das imagens-base novamente, execute `setup.sh`.
