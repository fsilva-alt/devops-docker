# Desafio 3 — Ciclo de vida

⏱ 5 minutos · Módulo 1: Fundamentos

## Objetivo

Executar um container em **segundo plano**, ou seja, mantendo o terminal disponível para outros comandos. Você vai consultar os **logs** (mensagens produzidas pelo programa), parar o container, iniciá-lo novamente e removê-lo.

## Onde

Em qualquer pasta.

## O ciclo

```
docker run -d ──▶ rodando ──docker stop──▶ parado ──docker rm──▶ (não existe mais)
                     ▲                        │
                     └──────docker start──────┘
```

`stop` pede ao programa que encerre e, por padrão neste ambiente, espera até 10 segundos antes de forçar o encerramento. `start` inicia o **mesmo** container, com os mesmos arquivos. `rm` remove um container parado; com `-f`, também pode remover um container em execução.

## Tarefa

1. Crie um container que continue em execução, mostrando a data e a hora a cada segundo. A opção `-d` deixa o programa em segundo plano. O comando mostra o **ID**, uma sequência de caracteres que identifica o container:

   ```bash
   docker run -d --name relogio alpine sh -c 'while true; do date; sleep 1; done'
   ```

   `alpine` é uma imagem Linux pequena, de cerca de 5 MB. O trecho entre aspas repete dois comandos: `date`, que mostra a data e a hora, e `sleep 1`, que espera um segundo. Você pode copiá-lo como está.

2. Confira o estado do container e suas mensagens. `Up ... seconds` indica que ele está em execução. No último comando, pressione **Ctrl+C** para parar de acompanhar os logs e continuar o exercício; o container seguirá rodando:

   ```bash
   docker ps
   docker logs relogio
   docker logs -f relogio      # segue os logs ao vivo; Ctrl+C sai (do logs, não do container)
   ```

3. Pare e observe as duas listas:

   ```bash
   docker stop relogio
   docker ps                   # vazio
   docker ps -a                # Exited
   ```

4. Inicie de novo. É o mesmo container: os logs antigos continuam lá, e novos vão aparecendo:

   ```bash
   docker start relogio
   docker logs --tail 3 relogio
   ```

5. Crie um container chamado `descartavel` e tente removê-lo enquanto ele está rodando. O comando `sleep 600` apenas espera 600 segundos:

   ```bash
   docker run -d --name descartavel alpine sleep 600
   docker rm descartavel                 # erro: está rodando
   docker stop descartavel && docker rm descartavel
   ```

   O erro em `docker rm descartavel` é esperado, porque o container ainda está rodando. Na última linha, `&&` executa a remoção somente se a parada funcionar. Outra opção é `docker rm -f descartavel`, que força o encerramento e remove o container.

Termine com o `relogio` rodando e o `descartavel` removido.

## Verificação

```bash
check.sh 03
```

## Dicas

- O `docker stop relogio` pode levar cerca de 10 segundos. Neste exemplo, o programa não responde ao pedido de encerramento, chamado `SIGTERM`. Depois da espera, o Docker força o encerramento com `SIGKILL`. Isso não significa que o terminal travou.
- Sem `--name`, o Docker inventa um nome (`brave_curie`, `sad_turing`...). Nomear facilita todos os comandos seguintes.
- Nos comandos que recebem um container, você pode usar o nome **ou** o início do ID, desde que ele identifique apenas um container. Para este exercício, use `relogio` e `descartavel`.

## Missão extra

Consulte mais informações sem abrir um terminal dentro do container: `docker top relogio` lista os processos, isto é, os programas em execução; `docker stats --no-stream relogio` mostra o uso de processador e memória; e `docker inspect relogio` mostra os detalhes em **JSON**, um formato de texto que organiza dados em nomes e valores. Nessa última saída, procure `"State"`, a seção sobre o estado do container.
