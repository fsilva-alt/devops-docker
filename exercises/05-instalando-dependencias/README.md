# Desafio 5 — Instalando dependências

⏱ 6 minutos · Módulo 2: Dockerfile

## Objetivo

Colocar numa imagem um programa que **depende de bibliotecas** (o FastAPI e o servidor uvicorn), instalando-as durante o build com `RUN`. A partir daqui, o projeto é uma pequena API web.

## Onde

```bash
cd ~/labs/05-instalando-dependencias
```

## Estado inicial

- `app.py`: uma API em FastAPI com duas rotas, `/` e `/receitas`. Leia o arquivo.
- `requirements.txt`: a lista de dependências (`fastapi` e `uvicorn`).

Se você tentar `python3 app.py` no Codespace, vai faltar o FastAPI. É exatamente o problema que a imagem resolve: ela leva as dependências junto.

## Duas instruções novas

| Instrução | O que faz |
|---|---|
| `WORKDIR /app` | Define a pasta atual dentro da imagem (e a cria). `COPY`, `RUN` e `CMD` passam a acontecer nela |
| `RUN comando` | Executa um comando **durante o build** e guarda o resultado na imagem. É assim que se instala qualquer coisa |

`RUN` acontece uma vez, no build. `CMD` acontece a cada `docker run`.

## Tarefa

1. Crie o `Dockerfile`:

   ```dockerfile
   FROM python:3.12-slim

   WORKDIR /app

   COPY . .
   RUN pip install --no-cache-dir -r requirements.txt

   CMD ["python", "app.py"]
   ```

   `COPY . .` copia tudo da pasta atual (o contexto) para o `WORKDIR`. O `--no-cache-dir` só evita que o pip guarde arquivos temporários na imagem.

2. Construa e acompanhe o `pip install` rodando **dentro** do build:

   ```bash
   docker build -t receitas-api:1.0 .
   ```

3. Confira que as bibliotecas ficaram na imagem:

   ```bash
   docker run --rm receitas-api:1.0 pip list
   ```

4. Rode a API. Ela sobe e fica esperando conexões; `Ctrl+C` encerra:

   ```bash
   docker run --rm receitas-api:1.0
   ```

   Você ainda **não consegue** acessá-la pelo navegador: a porta 8000 existe só dentro do container. Isso é o desafio 8.

## Verificação

```bash
check.sh 05
```

## Dicas

- Cada `RUN` vira uma **camada** da imagem. Se o `pip install` falhar, o build para ali e mostra o erro; corrija e construa de novo.
- A tag agora é `receitas-api`, não `receitas`: são projetos diferentes (script vs. API). Tag é só um nome; você escolhe.

## Missão extra

Compare tamanhos: `docker images` mostra `python:3.12-slim` e `receitas-api:1.0`. A diferença é o FastAPI, o uvicorn e o seu código. Veja também `docker run --rm receitas-api:1.0 python -c "import fastapi; print(fastapi.__version__)"`.
