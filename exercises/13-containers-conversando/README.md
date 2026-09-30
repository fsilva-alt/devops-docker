# Desafio 13 — Containers conversando

⏱ 6 minutos · Módulo 5: Vários containers

## Objetivo

Você vai fazer um container chamar outro **pelo nome**, numa rede criada por você, sem publicar porta nenhuma para fora.

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

1. Construa a API e prepare a rede. A segunda linha consulta `cozinha` e só a cria se ela ainda não existir (`||` executa o segundo comando quando o primeiro falha):

   ```bash
   docker build -t receitas-api:1.6 .
   docker network inspect cozinha >/dev/null 2>&1 || docker network create cozinha
   docker network ls
   ```

   Se você já executou `docker network create cozinha` e recebeu *already exists*, pode usar a rede existente. `docker ps` vazio significa que não há containers rodando; a rede continua existindo e aparece em `docker network ls`.

2. Inicie a API na rede `cozinha`, com o nome `receitas` e **sem `-p`**:

   ```bash
   docker run -d --name receitas --network cozinha receitas-api:1.6
   docker logs receitas
   ```

   Procure `Uvicorn running on http://0.0.0.0:8000`. Se ainda não apareceu, consulte os logs novamente após alguns segundos. Se o nome `receitas` já estiver em uso por uma tentativa anterior, execute `docker rm -f receitas` e repita o `docker run`.

   Agora tente o endereço abaixo no terminal do Codespace. Se nenhum outro programa estiver usando a porta 8000, a conexão deve ser recusada: não publicamos essa porta. Esse erro é esperado e não testa a comunicação entre containers:

   ```bash
   curl --noproxy '*' --max-time 3 localhost:8000/receitas
   ```

3. Execute `cliente.py` em outro container, conectado à mesma rede. Esse programa faz um pedido à API pelo nome `receitas`. A opção `-v` compartilha a pasta que contém `cliente.py`, como no desafio 10:

   ```bash
   docker run --rm --network cozinha -v "$PWD:/app" python:3.12-slim python /app/cliente.py
   ```

   A saída deve mostrar a lista de receitas recebida da API. O cliente faz até oito tentativas curtas enquanto a API inicia e se conecta diretamente à rede Docker, sem usar proxies HTTP externos. Se terminar com erro, siga o diagnóstico abaixo; um timeout persistente não é resultado esperado.

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

1. Confira o programa **dentro do próprio container**:

   ```bash
   docker ps -a --filter name=receitas
   docker logs receitas
   docker exec receitas python -c 'import http.client; c = http.client.HTTPConnection("127.0.0.1", 8000, timeout=3); c.request("GET", "/receitas"); print(c.getresponse().read().decode())'
   ```

   Se esse último comando falhar, corrija primeiro o erro dos logs. Se ele mostrar as receitas, a API funciona internamente; falta conferir o acesso pela rede. `127.0.0.1` aqui aponta para o container `receitas`, porque usamos `docker exec`.

2. Confira se o nome é encontrado a partir de **outro container**:

   ```bash
   docker network inspect cozinha
   docker run --rm --network cozinha python:3.12-slim python -c 'import socket; print(socket.gethostbyname("receitas"))'
   ```

   Deve aparecer o IP da API na rede `cozinha`. Se o nome não for encontrado, confira `--name receitas` e `--network cozinha` no comando que criou a API. Encontrar o IP comprova o DNS, mas ainda não comprova a conexão HTTP.

3. Se o nome resolve e a API responde internamente, mas o cliente continua com timeout, teste a rede do ambiente:

   ```bash
   check.sh 00
   ```

   Essa verificação cria e remove uma rede temporária com dois containers. Se ela também falhar, pare e reabra o mesmo Codespace e repita a verificação. Se o problema ocorrer apenas na rede do desafio, recrie seus recursos:

   ```bash
   docker rm -f receitas
   docker network rm cozinha
   docker network create cozinha
   docker run -d --name receitas --network cozinha receitas-api:1.6
   docker run --rm --network cozinha -v "$PWD:/app" python:3.12-slim python /app/cliente.py
   ```

   Se a remoção da rede informar que há outros containers conectados, use `docker network inspect cozinha` para identificá-los antes de decidir o que remover. Se o timeout persistir, guarde as saídas dos testes e peça ajuda. Publicar uma porta ou acrescentar `EXPOSE` não resolve uma falha de comunicação interna da rede.

Se você instalou o curso antes desta correção, atualize-o com o instalador, guarde as alterações que quiser manter e execute `reset.sh 13`. Depois, entre novamente na pasta e refaça o desafio para usar o cliente atualizado.

## Missão extra

Rode o cliente **sem** `--network cozinha` e leia o erro: fora da rede, o nome `receitas` não existe. Depois compare `docker network inspect bridge` com `docker network inspect cozinha`.
