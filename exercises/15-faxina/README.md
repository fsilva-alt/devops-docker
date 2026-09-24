# Desafio 15 — Faxina

⏱ 4 minutos · Encerramento · desafio elástico

## Objetivo

Descobrir quanto disco o Docker está usando e limpar o que sobrou da aula: containers parados, imagens sem nome, redes e volumes esquecidos. **Faça este desafio por último**: ele apaga o trabalho dos anteriores.

## Onde

Em qualquer pasta.

## Onde o disco vai

Tudo o que você fez hoje continua ocupando espaço: cada `docker run` sem `--rm` deixou um container parado; cada `build` que substituiu uma tag deixou uma imagem `<none>` (*dangling*) para trás. `docker system df` mostra o total por categoria e quanto dele é **reclaimable** (recuperável).

## Tarefa

1. Veja a conta:

   ```bash
   docker system df
   docker ps -a
   ```

2. Pare tudo o que está rodando e remova os parados. O `prune` pede confirmação (`y`):

   ```bash
   docker stop $(docker ps -q)
   docker container prune
   ```

   `$(docker ps -q)` vira a lista de IDs dos containers rodando; se não houver nenhum, o `stop` reclama que faltou argumento, e está tudo bem.

3. Remova as imagens sem nome, sobras dos builds:

   ```bash
   docker image prune
   docker images
   ```

4. Compare:

   ```bash
   docker system df
   ```

## Verificação

```bash
check.sh 15
```

Aprova sem nenhum container (rodando ou parado) e sem imagens `<none>`.

## Dicas

- Depois da faxina, `check.sh` dos desafios anteriores volta a reprovar. É esperado: os containers deles não existem mais. `reset.sh NN` e o enunciado recriam qualquer um em segundos.
- Prune só apaga o que **não está em uso**. Uma imagem com um container (mesmo parado) apontando para ela não é removida.

## Missão extra

Apague também o que tem nome: o volume, a rede e as imagens do curso. A verificação reconhece a extra quando nada do curso sobrou.

```bash
cd ~/labs/14-docker-compose && docker compose down && cd -
docker volume rm notas
docker network rm cozinha
docker images                                   # veja o que sobrou com nome
docker image rm -f $(docker images -q 'receitas*' | sort -u) bloco:1.0
```

(`docker images -q 'receitas*'` lista os IDs de `receitas`, `receitas-api` e `receitas-web`; o `-f` é para as imagens que têm duas tags, como `receitas:1.0` e `receitas:latest`.)

E o botão vermelho: `docker system prune -a --volumes` remove **tudo** o que não está em uso, imagens-base inclusive. Leia o aviso antes de responder `y`; na próxima aula, o `setup.sh` baixa tudo de novo.
