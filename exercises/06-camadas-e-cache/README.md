# Desafio 6 — Camadas e cache

⏱ 5 minutos · Módulo 2: Dockerfile

## Objetivo

Entender por que a **ordem** das instruções importa: cada uma vira uma camada, e o Docker reaproveita camadas até a primeira que mudou. Bem ordenado, mudar o código não reinstala as dependências.

## Onde

```bash
cd ~/labs/06-camadas-e-cache
```

## Estado inicial

`app.py`, `requirements.txt` e um `Dockerfile` igual ao do desafio 5: `COPY . .` **antes** do `pip install`.

## Como o cache funciona

O build vai de cima para baixo. Para cada instrução, o Docker pergunta: "já construí esta camada, com esta instrução, sobre a mesma camada anterior, com os mesmos arquivos?" Se sim, `CACHED`, custo zero. Se não, executa, **e todas as instruções seguintes também**, porque partem de uma base diferente.

Com `COPY . .` antes do `pip install`, qualquer edição em `app.py` muda a camada do `COPY`, e o `pip install` roda de novo, embora `requirements.txt` não tenha mudado.

## Tarefa

1. Construa uma vez:

   ```bash
   docker build -t receitas-api:1.1 .
   ```

2. Mude o código: abra `app.py` e acrescente uma receita à lista `RECEITAS`, por exemplo `{"nome": "Mousse de maracujá", "rende": "6 porções"}`. Construa de novo e repare: o `pip install` **rodou outra vez**, demorado, por uma mudança que não tinha nada a ver com ele.

   ```bash
   docker build -t receitas-api:1.1 .
   ```

3. Reordene o `Dockerfile`: primeiro só o `requirements.txt`, depois o pip, e só então o resto:

   ```dockerfile
   FROM python:3.12-slim

   WORKDIR /app

   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt

   COPY . .

   CMD ["python", "app.py"]
   ```

4. Construa (o pip roda uma última vez, porque a sequência de camadas é nova). Depois mude `app.py` de novo (outra receita, ou um texto) e construa mais uma vez: agora o pip aparece como `CACHED` e o build leva segundos.

   ```bash
   docker build -t receitas-api:1.1 .
   # edite app.py
   docker build -t receitas-api:1.1 .
   ```

5. Veja as camadas da imagem, uma por instrução, com o tamanho de cada uma:

   ```bash
   docker history receitas-api:1.1
   ```

## Verificação

```bash
check.sh 06
```

Aprova quando o `Dockerfile` está na ordem certa, o `app.py` foi alterado e a imagem contém a versão atual dele.

## Dica

A regra geral: **o que muda menos vai primeiro** (sistema, dependências), **o que muda mais vai por último** (o seu código).

## Missão extra

`docker build --no-cache -t receitas-api:1.1 .` ignora o cache e refaz tudo. Cronometre com `time` na frente e compare com um build normal.
