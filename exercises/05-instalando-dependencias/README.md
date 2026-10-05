# Exercício 5 — Instalando dependências

⏱ 6 minutos · Módulo 2: Dockerfile

## Objetivo

Desta vez, a imagem inclui o programa e as **dependências** dele, ou seja, os outros pacotes de software de que ele precisa. O FastAPI e o uvicorn são instalados com `RUN`, durante a construção da imagem.

O livro de receitas agora é uma **API**: um programa que recebe pedidos pela rede e responde com dados. O FastAPI ajuda a definir essas respostas, e o uvicorn é o servidor que recebe os pedidos. O código já está pronto.

## Onde

```bash
cd ~/labs/05-instalando-dependencias
```

## Estado inicial

- `app.py`: o programa da API. Ele tem duas **rotas**, que são caminhos de acesso. A rota `/` mostra uma mensagem inicial, e `/receitas` devolve a lista de receitas. Para ler o código, abra com `code app.py`.
- `requirements.txt`: a lista de dependências (`fastapi` e `uvicorn`).

Para executar `app.py` direto no Codespace, seria preciso instalar o FastAPI e o uvicorn nele. Em vez disso, eles vão ser instalados na imagem, junto com o programa.

## Duas instruções novas

| Instrução | O que faz |
|---|---|
| `WORKDIR /app` | Define a pasta de trabalho dentro da imagem e a cria, se necessário. Os caminhos relativos das instruções seguintes usam essa pasta como referência |
| `RUN comando` | Executa um comando **durante a construção da imagem**. Aqui, será usado para instalar as dependências |

A diferença entre `RUN` e `CMD` está no momento. `RUN` roda na construção, e o resultado pode ser reaproveitado em construções posteriores. `CMD` só define o comando padrão para quando o container iniciar.

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

2. Construa a imagem e acompanhe o `pip install` rodando dentro do build:

   ```bash
   docker build -t receitas-api:1.0 .
   ```

3. Confira que as bibliotecas ficaram na imagem:

   ```bash
   docker run --rm receitas-api:1.0 pip list
   ```

4. Execute a API. Ela fica esperando pedidos, então o terminal não volta a ficar livre sozinho. Depois de ler as mensagens, pressione **Ctrl+C** para encerrá-la:

   ```bash
   docker run --rm receitas-api:1.0
   ```

   Você ainda **não consegue** acessá-la pelo navegador, porque a porta 8000 existe só dentro do container. O exercício 8 resolve isso.

## Verificação

```bash
check.sh 05
```

## Dicas

- Cada `RUN` vira uma **camada** da imagem. Se o `pip install` falhar, o build para ali e mostra o erro; corrija e construa de novo.
- A imagem agora se chama `receitas-api`, com a tag `1.0`, para não se confundir com a do programa anterior, `receitas:1.0`. Use exatamente os nomes pedidos, senão a verificação não encontra a imagem.

## Missão extra

Na saída de `docker images`, compare o tamanho de `python:3.12-slim` com o de `receitas-api:1.0`. A diferença corresponde ao FastAPI, ao uvicorn e ao seu código. Para ver a versão do FastAPI instalada, execute `docker run --rm receitas-api:1.0 python -c "import fastapi; print(fastapi.__version__)"`.
