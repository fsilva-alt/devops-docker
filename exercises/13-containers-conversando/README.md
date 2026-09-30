# Exercício 13 — Containers conversando

⏱ 6 minutos · Módulo 5: Vários containers

## Objetivo

Você vai fazer um container chamar outro **pelo nome**, numa rede criada por você, sem publicar porta nenhuma para fora.

## Onde

```bash
cd ~/labs/13-containers-conversando
```

## Estado inicial

A API (`app.py`, `requirements.txt`, `Dockerfile` completo) e um `cliente.py`, que busca `http://receitas:8000/receitas` e imprime o resultado. Repare que `receitas` é um nome, não um endereço IP.

## Redes

Quando você não escolhe outra rede, o Docker usa a rede padrão, chamada `bridge`. Nela, a comunicação entre containers usa endereços **IP**, números que identificam cada participante da rede.

Em uma rede criada por você, o Docker também oferece **DNS**, um serviço que encontra o endereço IP a partir de um nome. Assim, o programa pode usar `receitas` no endereço, sem precisar saber o IP do container.

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
   docker logs receitas
   ```

   Procure `Uvicorn running on http://0.0.0.0:8000`. Se ainda não apareceu, consulte os logs novamente após alguns segundos. Se o nome `receitas` já estiver em uso por uma tentativa anterior, execute `docker rm -f receitas` e repita o `docker run`.

   Agora tente acessar a API pelo terminal do Codespace. Como a porta 8000 não foi publicada, a conexão deve ser recusada, a não ser que outro programa esteja usando essa porta. Esse erro é esperado e não diz nada sobre a comunicação entre containers:

   ```bash
   curl --noproxy '*' --max-time 3 localhost:8000/receitas
   ```

3. Execute `cliente.py` em outro container, conectado à mesma rede. Esse programa faz um pedido à API pelo nome `receitas`. A opção `-v` compartilha a pasta que contém `cliente.py`, como no exercício 10:

   ```bash
   docker run --rm --network cozinha -v "$PWD:/app" python:3.12-slim python /app/cliente.py
   ```

   A saída deve mostrar a lista de receitas recebida da API. Enquanto a API inicia, o cliente faz até oito tentativas curtas, conectando-se direto pela rede Docker, sem passar por proxies HTTP externos. Se ele terminar com erro, mesmo que seja um timeout, siga o diagnóstico abaixo.

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

## Se a API não responder

Confira `docker logs receitas`. Se a API estiver rodando, mas o cliente terminar com timeout, execute `rede.sh` e repita o cliente; o script corrige um bloqueio de firewall que acontece em alguns Codespaces. Se o erro continuar, envie os logs e a saída de `docker network inspect cozinha` ao pedir ajuda.

## Missão extra

Rode o cliente **sem** `--network cozinha` e leia o erro: fora da rede, o nome `receitas` não existe. Depois compare `docker network inspect bridge` com `docker network inspect cozinha`.
