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

Quando você não escolhe outra rede, o Docker usa a rede padrão, chamada `bridge`. Nela, a comunicação entre containers usa endereços **IP**, números que identificam cada participante da rede.

Em uma rede **criada por você**, o Docker também oferece **DNS**, um serviço que encontra o endereço IP a partir de um nome. Assim, o programa pode usar `receitas` no endereço, sem precisar saber o IP do container.

```
rede "cozinha"
┌──────────────────────────────────────────────┐
│  receitas:8000  ◀── http://receitas:8000 ──  cliente  │
└──────────────────────────────────────────────┘
        (nenhuma porta publicada para fora)
```

`-p` publica uma porta no Codespace. Entre containers da mesma rede, isso não é necessário: o cliente acessa diretamente a porta 8000 do container `receitas`.

## Tarefa

1. Construa a API e crie a rede:

   ```bash
   docker build -t receitas-api:1.6 .
   docker network create cozinha
   docker network ls
   ```

2. Inicie a API na rede `cozinha`, com o nome `receitas` e **sem `-p`**:

   ```bash
   docker run -d --name receitas --network cozinha receitas-api:1.6
   ```

   Agora tente o endereço abaixo no terminal do Codespace. A conexão deve ser recusada, pois não publicamos a porta 8000 no Codespace. Esse erro é esperado:

   ```bash
   curl localhost:8000/receitas
   ```

3. Execute `cliente.py` em outro container, conectado à mesma rede. Esse programa faz um pedido à API pelo nome `receitas`. A opção `-v` compartilha a pasta que contém `cliente.py`, como no desafio 10:

   ```bash
   docker run --rm --network cozinha -v "$PWD:/app" python:3.12-slim python /app/cliente.py
   ```

   A saída deve mostrar a lista de receitas recebida da API.

4. Consulte os containers conectados à rede. Como o cliente termina e é removido por `--rm`, ele já não deve aparecer; a API continua conectada:

   ```bash
   docker network inspect cozinha
   ```

## Verificação

```bash
check.sh 13
```

A verificação inicia um container temporário na rede `cozinha` e testa o endereço `http://receitas:8000/receitas` a partir dele.

## Dicas

- O nome usado no endereço é o que você definiu com `--name`. Se não informar um nome, o Docker gera um automaticamente, como `brave_curie`.
- Um container pode estar em várias redes (`docker network connect`).

## Missão extra

Rode o cliente **sem** `--network cozinha` e leia o erro: fora da rede, o nome `receitas` não existe. Depois compare `docker network inspect bridge` com `docker network inspect cozinha`.
