---
duration: 6
---

# Instalando dependências

{.lead}
Instalar na imagem as **dependências** do programa, que são os outros pacotes de software de que ele precisa. O livro de receitas agora é uma **API**, um programa que recebe pedidos pela rede e responde com dados.

`WORKDIR /app` `COPY . .` `RUN pip install -r requirements.txt` `docker build -t receitas-api:1.0 .`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/05-instalando-dependencias
```

`app.py` é o programa da API, já pronto. Ele usa o FastAPI e o uvicorn, listados em `requirements.txt`. Neste exercício, esses pacotes são instalados na imagem.
:::
:::card Para este exercício
`⏱ tempo`
: 6 min

`parte`
: Dockerfile

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
| `RUN comando` | roda um comando durante a construção; aqui, instala os pacotes do Python |
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

Você não precisa mexer nesse código. O FastAPI define as **rotas**, que são caminhos como `/receitas`. O uvicorn é o servidor que recebe os pedidos e devolve as respostas, na porta `8000`. O acesso a essa porta fica para o exercício 8.
:::

:::note Como ler pip install:
`pip` é o instalador de pacotes do Python, `-r requirements.txt` indica a lista de pacotes e `--no-cache-dir` evita guardar os arquivos de download na imagem. Se a instalação falhar, o build para e mostra o erro.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `WORKDIR /app` | pasta de trabalho dentro da imagem |
| `RUN pip install --no-cache-dir -r requirements.txt` | instala as dependências no build |
| `CMD ["python", "app.py"]` | o que roda a cada docker run |
| `docker run --rm <imagem> pip list` | roda outro comando no lugar do CMD, para olhar dentro da imagem |
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

## O exercício

:::steps
1. Rode `code Dockerfile`, copie as cinco instruções do slide anterior e salve. Mantenha a ordem do exemplo. O próximo exercício mostra como melhorá-la.

2. Construa a imagem e acompanhe o `pip install` rodando dentro do build:

   ```console
   $ docker build -t receitas-api:1.0 .
   ```

3. Confira que as bibliotecas ficaram na imagem:

   ```console
   $ docker run --rm receitas-api:1.0 pip list
   ```

4. Rode a API e leia as mensagens. Ela fica esperando pedidos, então o terminal não volta sozinho. Pressione <kbd>Ctrl+C</kbd> para encerrar. Ainda não dá para abrir a API no navegador, porque a porta 8000 só existe dentro do container. O exercício 8 resolve isso.

   ```console
   $ docker run --rm receitas-api:1.0
   ```
:::

:::card Verificação
```console
$ check.sh 05
```

Confere o `WORKDIR` e o `pip install` no Dockerfile, o FastAPI instalado na imagem e o `CMD` rodando o `app.py`.
:::

:::note
**Nome e tag:** a imagem agora se chama `receitas-api`, com a tag `1.0`, para não se confundir com a do programa anterior, `receitas:1.0`. Use exatamente esses nomes, senão a verificação não encontra a imagem.
:::

:::card Missão extra
```console
$ docker images
$ docker run --rm receitas-api:1.0 python -c "import fastapi; print(fastapi.__version__)"
```

Compare o tamanho de `python:3.12-slim` com o de `receitas-api:1.0`. A diferença é o FastAPI, o uvicorn e o seu código.
:::
