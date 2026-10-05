---
duration: 5
---

# Ciclo de vida

{.lead}
Executar um container em **segundo plano**, mantendo o terminal livre. Consultar os **logs**, que são as mensagens do programa, e praticar como parar, iniciar e remover containers.

`docker run -d --name` `docker logs -f` `docker stop` `docker start` `docker rm` `docker rm -f`

::::columns
:::card Onde fazer
No terminal do Codespace, em **qualquer pasta**. Estes comandos usam recursos gerenciados pelo Docker e não dependem de arquivos da pasta atual.
:::
:::card Para este desafio
`⏱ tempo`
: 5 min

`módulo`
: Módulo 1 · Fundamentos

`verificação`
: `check.sh 03`
:::
::::

<p class="eyebrow">Conceito</p>

## O ciclo

<div class="flow"><div class="node"><b>docker run -d</b><small>cria e inicia</small></div><div class="arr"><span class="a">→</span></div><div class="node hi"><b>rodando</b><small>Up · docker ps · docker logs</small></div><div class="arr"><span class="a">→</span><strong>docker stop</strong></div><div class="node"><b>parado</b><small>Exited · só em docker ps -a</small></div><div class="arr"><span class="a">→</span><strong>docker rm</strong></div><div class="node dim"><b>não existe mais</b><small>logs e camada gravável somem</small></div></div>

::::columns
:::card Iniciar novamente: start
`docker start` inicia o **mesmo** container, com os arquivos e logs anteriores. Já `docker run` cria um novo container.
:::
:::card Parar: stop
Envia ao programa um pedido de encerramento, chamado `SIGTERM`. Neste ambiente, a espera padrão é de até 10 segundos. Se o programa não encerrar, o Docker força a parada com `SIGKILL`.
:::
:::card Remover: rm
`docker rm` remove um container parado. Se ele estiver rodando, aparece um erro. A opção `-f` força o encerramento e a remoção, sem a espera de `stop`.
:::
::::

:::note -d: execução em segundo plano.
O comando mostra o ID, uma sequência que identifica o container, e libera o terminal. Use `docker logs` para ler as mensagens ou `docker logs -f` para acompanhá-las. <kbd>Ctrl+C</kbd> encerra esse acompanhamento, mas mantém o container rodando.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker run -d --name <n> <imagem> <cmd>` | em segundo plano, com nome |
| `docker logs <n>` | a saída do processo; -f segue ao vivo; --tail N as últimas linhas |
| `docker stop <n>` | pede o encerramento e aguarda; neste ambiente, o prazo padrão é de 10 s |
| `docker start <n>` | inicia novamente o mesmo container |
| `docker rm <n>` | remove um container parado; -f remove mesmo rodando |
| `docker top <n>` | lista os processos, isto é, os programas em execução no container |
| `docker stats --no-stream <n>` | mostra o uso de processador e memória naquele momento |
| `docker inspect <n>` | mostra detalhes do container em JSON |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Guia para executar containers](https://docs.docker.com/engine/containers/run/)<small>opções de docker run · em inglês</small>
- [Comando · docker logs](https://docs.docker.com/reference/cli/docker/container/logs/)<small>-f, --tail</small>
- [Comando · docker stop](https://docs.docker.com/reference/cli/docker/container/stop/)
- [Comando · docker start](https://docs.docker.com/reference/cli/docker/container/start/)<small>-ai</small>
- [Comando · docker rm](https://docs.docker.com/reference/cli/docker/container/rm/)<small>-f</small>
- [Comando · docker ps](https://docs.docker.com/reference/cli/docker/container/ls/)<small>-a, --filter, --format</small>
- [Docker Hub · alpine](https://hub.docker.com/_/alpine)<small>a imagem Linux de 5 MB</small>
:::

<p class="eyebrow">Tarefa · 5 min</p>

## O desafio

:::steps
1. Crie um relógio que mostra a hora a cada segundo. O trecho entre aspas repete `date` (data e hora) e `sleep 1` (espera de um segundo). Você pode copiá-lo como está:

   ```console
   $ docker run -d --name relogio alpine sh -c 'while true; do date; sleep 1; done'
   ```

2. Rodando (`Up … seconds`) e escrevendo nos logs:

   ```console
   $ docker ps
   $ docker logs relogio
   $ docker logs -f relogio      # Ctrl+C sai do logs, não do container
   ```

3. Pare o relógio e compare as duas listas. Neste exemplo, a parada pode demorar cerca de 10 segundos; aguarde o terminal ficar disponível:

   ```console
   $ docker stop relogio
   $ docker ps                   # só os containers em execução
   $ docker ps -a                # inclui o relogio parado: Exited
   ```

4. Inicie de novo. Os logs antigos continuam, e novos vão aparecendo:

   ```console
   $ docker start relogio
   $ docker logs --tail 3 relogio
   ```

5. Crie outro container e tente removê-lo. O erro da segunda linha é esperado. Na terceira, `&&` executa a remoção apenas se a parada funcionar:

   ```console
   $ docker run -d --name descartavel alpine sleep 600
   $ docker rm descartavel                 # erro: está rodando
   $ docker stop descartavel && docker rm descartavel
   ```
:::

:::card Verificação
```console
$ check.sh 03
```

Aprova com o `relogio` rodando (e já parado e iniciado ao menos uma vez) e o `descartavel` removido.
:::

:::note
**Nome ou ID:** os comandos que recebem um container aceitam seu nome ou um início de ID que o identifique sem ambiguidade. Aqui, use `relogio` e `descartavel`.
:::

:::card Missão extra
```console
$ docker top relogio
$ docker stats --no-stream relogio
$ docker inspect relogio      # procure "State"
```

Consulte os programas em execução, o uso de processador e memória e os detalhes do container. `inspect` usa JSON, um formato de texto com nomes e valores.
:::
