---
duration: 6
---

# Desenvolvimento com Compose

{.lead}
Repetir o exercício 11 com o Compose: um **bind mount** descrito no `compose.yaml` compartilha a pasta com o serviço `api`, e você edita a API sem reconstruir a imagem.

`volumes: - .:/app` `image: receitas-api:dev` `docker compose exec` `docker compose logs`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/12-compose-desenvolvimento
```

`app.py` com `reload=True`, `requirements.txt`, `.dockerignore` e `Dockerfile` prontos. Esta pasta tem os próprios arquivos, então o projeto do exercício 11 fica como está. Só falta o `compose.yaml`.
:::
:::card Para este exercício
`⏱ tempo`
: 6 min · opcional, pode ficar para depois da aula

`parte`
: Dados

`verificação`
: `check.sh 12`
:::
::::

<p class="eyebrow">Conceito · o -v do exercício 11, em YAML</p>

## Bind mount no Compose

<div class="flow"><div class="node"><b>Codespace</b><small>~/labs/12-compose-desenvolvimento/app.py · você edita no VS Code</small></div><div class="arr"><span class="a">⇄</span><strong>volumes: - .:/app</strong><br>acesso aos mesmos arquivos</div><div class="node hi"><b>serviço api</b><small>/app/app.py · o uvicorn lê daqui</small></div></div>

```yaml
services:
  api:
    build: .
    image: receitas-api:dev
    ports:
      - "8100:8000"
    volumes:
      - .:/app
```

| Configuração | No docker run |
| --- | --- |
| `image: receitas-api:dev` | o nome da imagem construída, como em `docker build -t` |
| `ports:` | `-p 8100:8000` |
| `volumes: - .:/app` | `-v "$PWD:/app"`; o `.` é a pasta do `compose.yaml` |

:::note Bind mount ou volume
Em `volumes`, quando o que vem antes do `:` é um caminho, como `.`, é um bind mount. Quando é um nome, como `notas`, é um volume, assunto do exercício 14.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker compose up -d --build` | constrói a imagem e inicia o serviço |
| `docker compose logs api` | mostra a mensagem *Reloading* quando o código muda |
| `docker compose exec api <cmd>` | roda um comando no container do serviço |
| `docker compose down` | remove o container e a rede; os arquivos da pasta continuam lá |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Referência do arquivo Compose · volumes de um serviço](https://docs.docker.com/reference/compose-file/services/#volumes)<small>bind mounts e volumes · em inglês</small>
- [Como usar bind mounts](https://docs.docker.com/engine/storage/bind-mounts/)
- [Comando · docker compose exec](https://docs.docker.com/reference/cli/docker/compose/exec/)
:::

<p class="eyebrow">Tarefa · 6 min · pode ficar para depois da aula</p>

## O exercício

:::steps
1. Rode `code compose.yaml`, copie o conteúdo do slide anterior e salve.

2. Confira o arquivo e inicie o serviço. Nos logs, espere a mensagem de que a API iniciou:

   ```console
   $ docker compose config
   $ docker compose up -d --build
   $ docker compose logs api
   $ curl localhost:8100/receitas
   ```

3. Rode `code app.py`. Acrescente a linha abaixo à lista `RECEITAS`, antes do `]` final, com o mesmo alinhamento das outras receitas, e salve:

   ```python
   {"nome": "Pudim", "rende": "8 porções"},
   ```

4. Chame a API de novo. O Pudim aparece sem outro build:

   ```console
   $ curl localhost:8100/receitas
   $ docker compose exec api cat /app/app.py
   $ docker run --rm receitas-api:dev cat /app/app.py
   ```

   O arquivo que o serviço `api` lê tem o Pudim. O da imagem continua sem ele.
:::

:::card Verificação
```console
$ check.sh 12
```

Confere a pasta compartilhada, a porta 8100, o Pudim na resposta da API e a imagem ainda sem ele.
:::

:::card Missão extra
Acrescente ao serviço `api`, alinhado com `build`:

```yaml
    environment:
      COZINHA: "Cozinha de desenvolvimento"
```

Rode `docker compose up -d` e teste com `curl localhost:8100/`. Para mudar a configuração, o Compose recria o container. Já uma mudança no código, que chega pelo bind mount, não precisa disso. Ao terminar, `docker compose down` remove o container e a rede, sem apagar os arquivos da pasta.
:::
