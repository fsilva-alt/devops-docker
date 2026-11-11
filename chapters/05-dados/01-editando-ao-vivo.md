---
duration: 5
---

# Editando ao vivo

{.lead}
Editar o programa no VS Code e ver a mudança na API **sem reconstruir a imagem**. Isso funciona com um **bind mount**, que compartilha a pasta do projeto com o container.

`docker run -v "$PWD:/app"` `reload=True` `docker logs` `docker exec`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/11-editando-ao-vivo
```

A API completa. A diferença está no `app.py`, que chama `uvicorn.run("app:app", ..., reload=True)`. O `reload=True` faz o servidor reiniciar sozinho quando o arquivo muda.
:::
:::card Para este exercício
`⏱ tempo`
: 5 min

`parte`
: Dados

`verificação`
: `check.sh 11`
:::
::::

<p class="eyebrow">Conceito · a mesma pasta, vista dos dois lados</p>

## Bind mount

<div class="flow"><div class="node"><b>Codespace</b><small>~/labs/11-editando-ao-vivo/app.py · você edita no VS Code</small></div><div class="arr"><span class="a">⇄</span><strong>-v "$PWD:/app"</strong><br>acesso aos mesmos arquivos</div><div class="node hi"><b>container dev</b><small>/app/app.py · o uvicorn lê daqui</small></div></div>

<div class="layers"><div class="cap">o que o container enxerga em /app</div><div class="stk"><div class="layer rw"><b>/app  ← bind mount</b><small>pasta do Codespace acessível no container</small></div><div class="layer dim"><b>COPY . .  → /app</b><small>arquivos originais ocultos enquanto a montagem está ativa</small></div><div class="layer "><b>RUN pip install</b><small>FastAPI e uvicorn continuam vindo da imagem</small></div><div class="layer "><b>FROM python:3.12-slim</b></div></div></div>

:::card Como ler -v "$PWD:/app"
`$PWD` é o caminho completo da pasta atual no Codespace. `/app` é o caminho pelo qual o container acessa essa pasta. O compartilhamento é chamado de **montagem**.

Entre na pasta do exercício antes de rodar o comando, porque o `$PWD` é a pasta em que você está. Um nome no lugar do caminho, como em `-v notas:/dados`, indica um volume, assunto do exercício 13.
:::

:::note
**Durante o desenvolvimento:** compartilhar o código assim ajuda enquanto você edita e testa o programa. Para entregar essa versão a outras pessoas, construa uma imagem nova. Um bind mount também serve para passar ao container um arquivo de configuração que está fora da imagem.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker run -v "$PWD:/app" …` | monta a pasta atual em /app (bind mount) |
| `docker run -v "$PWD/site:/usr/share/nginx/html" …` | monta uma subpasta em outro caminho do container |
| `docker inspect <nome>` | em "Mounts": tipo, origem e destino de cada montagem |
| `docker exec <nome> ls /app` | lista o que o container vê em /app |
| `--mount type=bind,src=…,dst=…` | a forma longa do -v, com cada parte nomeada |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Como compartilhar arquivos com containers](https://docs.docker.com/get-started/docker-concepts/running-containers/sharing-local-files/)<small>bind mounts · em inglês</small>
- [Como usar bind mounts](https://docs.docker.com/engine/storage/bind-mounts/)
- [Comando · docker run](https://docs.docker.com/reference/cli/docker/container/run/)<small>-d, -it, --rm, --name, -p, -e, -v, --network</small>
- [Comando · docker exec](https://docs.docker.com/reference/cli/docker/container/exec/)
:::

<p class="eyebrow">Tarefa · 5 min</p>

## O exercício

:::steps
1. Construa a imagem e rode o container com a pasta montada:

   ```console
   $ docker build -t receitas-api:1.5 .
   $ docker run -d --name dev -p 8003:8000 -v "$PWD:/app" receitas-api:1.5
   $ curl localhost:8003/receitas
   ```

2. Rode `code app.py`. Acrescente a linha abaixo à lista `RECEITAS`, antes do `]` final, com o mesmo alinhamento das outras receitas:

   ```python
   {"nome": "Pudim", "rende": "8 porções"},
   ```

   Salve e veja os logs. Uma mensagem com *Reloading* mostra que o uvicorn percebeu a mudança e está recarregando o programa:

   ```console
   $ docker logs dev
   ```

3. Chame a API de novo. O Pudim aparece sem que você reconstrua a imagem nem reinicie o container:

   ```console
   $ curl localhost:8003/receitas
   ```
:::

:::card Verificação
```console
$ check.sh 11
```

Confere se esta pasta está montada em `/app` e se o Pudim aparece no `app.py` e na resposta da API.
:::

:::note Compare com a imagem:
`docker run --rm receitas-api:1.5 cat app.py` mostra o arquivo original, sem o Pudim, porque a imagem não mudou. O container `dev` lê o arquivo da sua pasta.
:::

:::card Missão extra
```console
$ docker exec dev sh -c 'echo "escrito de dentro" > /app/de-dentro.txt'
$ cat de-dentro.txt
$ rm de-dentro.txt
```

O arquivo criado dentro do container aparece na sua pasta, porque os dois acessam os mesmos arquivos. A última linha apaga o arquivo de teste, para que ele não entre nas próximas construções da imagem.
:::
