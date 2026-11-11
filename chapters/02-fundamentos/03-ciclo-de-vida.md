---
duration: 5
---

# Ciclo de vida

{.lead}
Rodar um container em **segundo plano**, com o terminal livre para outros comandos. Acompanhar os **logs**, as mensagens que o programa produz, e praticar como parar, iniciar de novo e remover containers.

`docker run -d --name` `docker logs -f` `docker stop` `docker start` `docker rm` `docker rm -f`

::::columns
:::card Onde fazer
No terminal do Codespace, em **qualquer pasta**. Quem cuida dos containers e das imagens é o Docker, então estes comandos não dependem da pasta em que você está.
:::
:::card Para este exercício
`⏱ tempo`
: 5 min

`parte`
: Fundamentos

`verificação`
: `check.sh 03`
:::
::::

<p class="eyebrow">Conceito</p>

## O ciclo

<div class="flow"><div class="node"><b>docker run -d</b><small>cria e inicia</small></div><div class="arr"><span class="a">→</span></div><div class="node hi"><b>rodando</b><small>Up · docker ps · docker logs</small></div><div class="arr"><span class="a">→</span><strong>docker stop</strong></div><div class="node"><b>parado</b><small>Exited · só em docker ps -a</small></div><div class="arr"><span class="a">→</span><strong>docker rm</strong></div><div class="node dim"><b>não existe mais</b><small>logs e camada gravável somem</small></div></div>

::::columns
:::card Iniciar de novo: start
`docker start` inicia o **mesmo** container, com os arquivos e os logs de antes. Já o `docker run` cria um container novo.
:::
:::card Parar: stop
`docker stop` pede ao programa que encerre, com um sinal chamado `SIGTERM`, e espera até 10 segundos. Se o programa não encerrar nesse tempo, o Docker força a parada com `SIGKILL`.
:::
:::card Remover: rm
`docker rm` remove um container parado. Se ele estiver rodando, aparece um erro. A opção `-f` força o encerramento e a remoção, sem a espera de `stop`.
:::
::::

:::note -d: execução em segundo plano.
O comando mostra o ID, uma sequência de caracteres que identifica o container, e devolve o terminal. `docker logs` mostra as mensagens do programa, e `docker logs -f` acompanha as novas ao vivo. Pressione <kbd>Ctrl+C</kbd> para sair do acompanhamento. O container segue rodando.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker run -d --name <n> <imagem> <cmd>` | em segundo plano, com nome |
| `docker logs <n>` | as mensagens do programa; -f acompanha ao vivo; --tail N mostra as últimas N linhas |
| `docker stop <n>` | pede ao programa que encerre e espera até 10 s |
| `docker start <n>` | inicia de novo o mesmo container |
| `docker rm <n>` | remove um container parado; -f remove mesmo rodando |
| `docker top <n>` | lista os processos, que são os programas em execução no container |
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

## O exercício

:::steps
1. Crie um container que mostra a data e a hora a cada segundo. O trecho entre aspas repete dois comandos: `date`, que mostra a data e a hora, e `sleep 1`, que espera um segundo. Copie o comando como está:

   ```console
   $ docker run -d --name relogio alpine sh -c 'while true; do date; sleep 1; done'
   ```

2. Confira o estado do container e as mensagens dele. `Up … seconds` indica que ele está rodando:

   ```console
   $ docker ps
   $ docker logs relogio
   $ docker logs -f relogio      # Ctrl+C sai do logs, não do container
   ```

3. Pare o relógio e compare as duas listas. O `stop` pode levar uns 10 segundos, e isso não quer dizer que o terminal travou:

   ```console
   $ docker stop relogio
   $ docker ps                   # só os containers em execução
   $ docker ps -a                # inclui o relogio parado: Exited
   ```

4. Inicie o container de novo. Como é o mesmo container, os logs antigos continuam lá, e os novos aparecem depois deles:

   ```console
   $ docker start relogio
   $ docker logs --tail 3 relogio
   ```

5. Crie outro container e tente removê-lo enquanto ele está rodando. O erro da segunda linha é esperado. Na terceira, o `&&` só roda a remoção se a parada der certo:

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

Aprova quando o `relogio` está rodando, depois de ter sido parado e iniciado ao menos uma vez, e o `descartavel` foi removido.
:::

:::note
**Nome ou ID:** nos comandos que recebem um container, você pode usar o nome ou o início do ID, desde que esse início identifique um único container. Aqui, use `relogio` e `descartavel`.
:::

:::card Missão extra
```console
$ docker top relogio
$ docker stats --no-stream relogio
$ docker inspect relogio      # procure "State"
```

Esses comandos mostram os programas em execução no container, o uso de processador e memória e os detalhes dele. O `inspect` responde em JSON, um formato de texto que organiza dados em nomes e valores.
:::
