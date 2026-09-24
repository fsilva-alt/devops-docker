# Desafio 3 — Ciclo de vida

⏱ 5 minutos · Módulo 1: Fundamentos

## Objetivo

Rodar um container em segundo plano, ler os logs dele, parar, iniciar de novo e remover. É o dia a dia com qualquer serviço em container.

## Onde

Em qualquer pasta.

## O ciclo

```
docker run -d ──▶ rodando ──docker stop──▶ parado ──docker rm──▶ (não existe mais)
                     ▲                        │
                     └──────docker start──────┘
```

`stop` manda o processo encerrar (e espera até 10 s antes de matar). `start` religa o **mesmo** container, com os mesmos arquivos. `rm` só funciona em container parado (ou com `-f`).

## Tarefa

1. Um container que fica vivo: um relógio que imprime a hora a cada segundo. O `-d` (*detached*) devolve o terminal para você na hora; a saída é o ID do container:

   ```bash
   docker run -d --name relogio alpine sh -c 'while true; do date; sleep 1; done'
   ```

   `alpine` é uma imagem Linux minúscula (uns 5 MB), boa para testes.

2. Ele está rodando (`Up ... seconds`) e escrevendo nos logs:

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

5. Removendo: crie um container descartável e tente removê-lo enquanto roda:

   ```bash
   docker run -d --name descartavel alpine sleep 600
   docker rm descartavel                 # erro: está rodando
   docker stop descartavel && docker rm descartavel
   ```

   (`docker rm -f descartavel` faz os dois de uma vez.)

Termine com o `relogio` rodando e o `descartavel` removido.

## Verificação

```bash
check.sh 03
```

## Dicas

- O `docker stop` do relógio demora uns 10 segundos. É normal: o `stop` pede educadamente (SIGTERM), o `sh` ignora, e só então o Docker mata o processo (SIGKILL). Programas bem-comportados encerram na hora; `docker stop -t 1` encurta a espera.
- Sem `--name`, o Docker inventa um nome (`brave_curie`, `sad_turing`...). Nomear facilita todos os comandos seguintes.
- Todo comando aceita o nome **ou** o começo do ID: `docker stop relogio` e `docker stop 3f2` dão no mesmo.

## Missão extra

Veja o container por dentro sem entrar nele: `docker top relogio` (processos), `docker stats --no-stream relogio` (CPU e memória) e `docker inspect relogio` (tudo, em JSON: procure `"State"`).
