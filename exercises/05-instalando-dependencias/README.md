# Desafio 5 — Instalando dependências

⏱ 6 minutos · Módulo 2: Dockerfile

## Objetivo

Construir uma imagem que inclua o programa e suas **dependências**, ou seja, os outros pacotes de software de que ele precisa. Vamos usar `RUN` para instalar o FastAPI e o uvicorn durante a construção da imagem.

O livro de receitas agora é uma **API**: um programa que recebe pedidos pela rede e responde com dados. O FastAPI ajuda a definir essas respostas, e o uvicorn é o servidor que recebe os pedidos. O código já está pronto.

## Onde

```bash
cd ~/labs/05-instalando-dependencias
```

## Estado inicial

- `app.py`: o programa da API, com duas **rotas** (caminhos de acesso): `/` mostra uma mensagem inicial, e `/receitas` fornece a lista de receitas. Abra com `code app.py` se quiser consultar o código.
- `requirements.txt`: a lista de dependências (`fastapi` e `uvicorn`).

Para executar `app.py` diretamente no Codespace, o FastAPI e o uvicorn teriam de estar instalados nele. Neste exercício, vamos instalá-los na imagem, junto com o programa.

## Duas instruções novas

| Instrução | O que faz |
|---|---|
| `WORKDIR /app` | Define a pasta de trabalho dentro da imagem e a cria, se necessário. Os caminhos relativos das instruções seguintes usam essa pasta como referência |
| `RUN comando` | Executa um comando **durante a construção da imagem**. Aqui, será usado para instalar as dependências |

`RUN` executa durante a construção da imagem; seu resultado pode ser reutilizado em construções posteriores. `CMD` define o comando padrão para quando o container iniciar.

## Tarefa

1. Execute `code Dockerfile`, copie o conteúdo abaixo para o arquivo e salve:

   ```dockerfile
   FROM python:3.12-slim

   WORKDIR /app

   COPY . .
   RUN pip install --no-cache-dir -r requirements.txt

   CMD ["python", "app.py"]
   ```

   Em `COPY . .`, o primeiro ponto representa a pasta do projeto, e o segundo, a pasta de trabalho `/app` dentro da imagem. `pip` é o instalador de pacotes do Python; `-r requirements.txt` indica a lista de pacotes a instalar. `--no-cache-dir` evita guardar os arquivos de download do pip na imagem.

2. Construa e acompanhe o `pip install` rodando **dentro** do build:

   ```bash
   docker build -t receitas-api:1.0 .
   ```

3. Confira que as bibliotecas ficaram na imagem:

   ```bash
   docker run --rm receitas-api:1.0 pip list
   ```

4. Execute a API. Ela ficará aguardando pedidos, por isso o terminal não ficará livre sozinho. Depois de observar as mensagens, pressione **Ctrl+C** para encerrar e continuar o exercício:

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
- O nome da imagem agora é `receitas-api`, e a tag é `1.0`. Isso diferencia a API do programa anterior, cuja imagem se chama `receitas:1.0`. Use os nomes pedidos no enunciado para que a verificação os encontre.

## Missão extra

Compare tamanhos: `docker images` mostra `python:3.12-slim` e `receitas-api:1.0`. A diferença é o FastAPI, o uvicorn e o seu código. Veja também `docker run --rm receitas-api:1.0 python -c "import fastapi; print(fastapi.__version__)"`.
