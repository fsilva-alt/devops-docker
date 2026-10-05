---
duration: 6
---

# Instalando dependências

{.lead}
Instalar na imagem os pacotes de software de que o programa precisa: suas **dependências**. Agora, o livro de receitas é uma **API**, um programa que recebe pedidos pela rede e responde com dados.

`WORKDIR /app` `COPY . .` `RUN pip install -r requirements.txt` `docker build -t receitas-api:1.0 .`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/05-instalando-dependencias
```

`app.py` é o programa, já pronto. Ele usa FastAPI e uvicorn, listados em `requirements.txt`. Vamos instalar esses pacotes na imagem.
:::
:::card Para este desafio
`⏱ tempo`
: 6 min

`módulo`
: Módulo 2 · Dockerfile

`verificação`
: `check.sh 05`
:::
::::

<p class="eyebrow">Conceito · RUN e CMD</p>

## Construir a imagem e executar o programa

<div class="flow"><div class="node hi"><b>build: construção</b><small><strong>RUN</strong> instala as dependências · o resultado fica na imagem</small></div><div class="arr"><span class="a">→</span>imagem pronta</div><div class="node"><b>run: execução</b><small><strong>CMD</strong> define o comando padrão ao iniciar o container</small></div></div>

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY . .
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "app.py"]
```

| Instrução | O que faz |
| --- | --- |
| `WORKDIR /app` | define a pasta de trabalho na imagem e a cria, se necessário |
| `RUN comando` | executa durante a construção; aqui, instala os pacotes do Python |
| `COPY . .` | copia da pasta do projeto (primeiro ponto) para a pasta de trabalho /app (segundo ponto) |

:::card O app.py, em resumo
```python
import uvicorn
from fastapi import FastAPI
app = FastAPI(title="Livro de receitas")

@app.get("/receitas")
def receitas():
    return RECEITAS

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

Este trecho é apenas para consulta. O FastAPI define as **rotas**, caminhos como `/receitas`. O uvicorn recebe os pedidos e envia as respostas. A porta `8000` identifica onde ele recebe conexões; veremos o acesso no desafio 8.
:::

:::note Como ler pip install:
`pip` instala pacotes Python; `-r requirements.txt` indica a lista de pacotes; `--no-cache-dir` evita guardar os arquivos de download na imagem. Se a instalação falhar, a construção para e mostra o erro.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `WORKDIR /app` | pasta de trabalho dentro da imagem |
| `RUN pip install --no-cache-dir -r requirements.txt` | instala as dependências no build |
| `CMD ["python", "app.py"]` | o que roda a cada docker run |
| `docker run --rm <imagem> pip list` | sobrescreve o CMD para inspecionar a imagem |
| `docker run --rm <imagem>` | roda o CMD; Ctrl+C encerra e o --rm remove |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Dockerfile · WORKDIR](https://docs.docker.com/reference/dockerfile/#workdir)
- [Dockerfile · RUN](https://docs.docker.com/reference/dockerfile/#run)
- [Dockerfile · CMD](https://docs.docker.com/reference/dockerfile/#cmd)
- [Como escrever um Dockerfile](https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/)<small>em inglês</small>
- [Docker Hub · python](https://hub.docker.com/_/python)<small>tags: 3.12-slim, 3.12-alpine…</small>
:::

<p class="eyebrow">Tarefa · 6 min</p>

## O desafio

:::steps
1. Execute `code Dockerfile`, copie as cinco instruções do slide anterior e salve. Mantenha a ordem do exemplo; no próximo desafio, vamos melhorá-la.

2. Construa e acompanhe o `pip install` rodando **dentro** do build:

   ```console
   $ docker build -t receitas-api:1.0 .
   ```

3. As bibliotecas ficaram na imagem:

   ```console
   $ docker run --rm receitas-api:1.0 pip list
   ```

4. Execute a API e observe as mensagens. Ela continuará aguardando pedidos. Pressione <kbd>Ctrl+C</kbd> para encerrar antes de verificar o desafio. O acesso pelo navegador será configurado no desafio 8.

   ```console
   $ docker run --rm receitas-api:1.0
   ```
:::

:::card Verificação
```console
$ check.sh 05
```

Confere WORKDIR, o pip no Dockerfile, o FastAPI dentro da imagem e o CMD rodando o app.py.
:::

:::note
**Nome e tag:** em `receitas-api:1.0`, o nome é `receitas-api`, e a tag é `1.0`. Isso distingue a API do programa anterior, `receitas:1.0`. Use os nomes do enunciado para que a verificação encontre as imagens.
:::

:::card Missão extra
```console
$ docker images
$ docker run --rm receitas-api:1.0 python -c "import fastapi; print(fastapi.__version__)"
```

A diferença de tamanho entre `python:3.12-slim` e `receitas-api:1.0` é o FastAPI, o uvicorn e o seu código.
:::
