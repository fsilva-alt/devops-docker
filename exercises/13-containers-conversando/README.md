# Desafio 13 — Containers conversando

⏱ 6 minutos · Módulo 5: Vários containers

## Objetivo

Fazer um container chamar outro **pelo nome**, numa rede criada por você, sem publicar porta nenhuma para fora.

## Onde

```bash
cd ~/labs/13-containers-conversando
```

## Estado inicial

A API (`app.py`, `requirements.txt`, `Dockerfile` completo) e um `cliente.py`, que busca `http://receitas:8000/receitas` e imprime o resultado. Repare: `receitas` é um **nome**, não um endereço IP.

## Redes

Todo container nasce na rede padrão (`bridge`), onde os outros só são alcançáveis por IP. Numa rede **criada por você**, o Docker inclui um DNS: o nome de cada container vira o endereço dele.

```
rede "cozinha"
┌──────────────────────────────────────────────┐
│  receitas:8000  ◀── http://receitas:8000 ──  cliente  │
└──────────────────────────────────────────────┘
        (nenhuma porta publicada para fora)
```

`-p` é para o mundo de fora; entre containers na mesma rede, não é necessário.

## Tarefa

1. Construa a API e crie a rede:

   ```bash
   docker build -t receitas-api:1.6 .
   docker network create cozinha
   docker network ls
   ```

2. Suba a API **na rede**, com nome, e **sem `-p`**:

   ```bash
   docker run -d --name receitas --network cozinha receitas-api:1.6
   ```

   De fora ela não responde (é proposital):

   ```bash
   curl localhost:8000/receitas
   ```

3. Rode o cliente em outro container, na mesma rede. Ele chama a API pelo nome (o `-v` só serve para levar o `cliente.py`, como no desafio 10):

   ```bash
   docker run --rm --network cozinha -v "$PWD:/app" python:3.12-slim python /app/cliente.py
   ```

4. Veja quem está na rede:

   ```bash
   docker network inspect cozinha
   ```

## Verificação

```bash
check.sh 13
```

A verificação sobe um container na rede `cozinha` e chama `http://receitas:8000/receitas` de lá.

## Dicas

- O nome que resolve é o `--name` do container. Sem nome, o Docker inventa um (`brave_curie`), e é esse que os outros teriam de usar.
- Um container pode estar em várias redes (`docker network connect`).

## Missão extra

Rode o cliente **sem** `--network cozinha` e leia o erro: fora da rede, o nome `receitas` não existe. Depois compare `docker network inspect bridge` com `docker network inspect cozinha`.
