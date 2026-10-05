---
duration: 5
---

# Editando ao vivo

{.lead}
Editar o programa no VS Code e ver a alteração na API **sem reconstruir a imagem**. Você vai compartilhar a pasta do projeto com o container usando um **bind mount**.

`docker run -v "$PWD:/app"` `reload=True` `docker logs` `docker exec`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/10-editando-ao-vivo
```

A API completa. Uma diferença no `app.py`: `uvicorn.run("app:app", ..., reload=True)`, que faz o servidor reiniciar sozinho quando o arquivo muda.
:::
:::card Para este desafio
`⏱ tempo`
: 5 min

`módulo`
: Módulo 4 · Dados

`verificação`
: `check.sh 10`
:::
::::

<p class="eyebrow">Conceito · a mesma pasta, vista dos dois lados</p>

## Bind mount

<div class="flow"><div class="node"><b>Codespace</b><small>~/labs/10-editando-ao-vivo/app.py · você edita no VS Code</small></div><div class="arr"><span class="a">⇄</span><strong>-v "$PWD:/app"</strong><br>acesso aos mesmos arquivos</div><div class="node hi"><b>container dev</b><small>/app/app.py · o uvicorn lê daqui</small></div></div>

<div class="layers"><div class="cap">o que o container enxerga em /app</div><div class="stk"><div class="layer rw"><b>/app  ← bind mount</b><small>pasta do Codespace acessível no container</small></div><div class="layer dim"><b>COPY . .  → /app</b><small>arquivos originais ocultos enquanto a montagem está ativa</small></div><div class="layer "><b>RUN pip install</b><small>FastAPI e uvicorn continuam vindo da imagem</small></div><div class="layer "><b>FROM python:3.12-slim</b></div></div></div>

:::card Como ler -v "$PWD:/app"
`$PWD` é o caminho completo da pasta atual no Codespace. `/app` é o caminho pelo qual o container acessa essa pasta. O compartilhamento é chamado de **montagem**.

Entre na pasta do desafio antes de executar o comando. Um nome no lugar de um caminho, como `-v notas:/dados`, indica um volume, assunto do desafio 11.
:::

:::note
**Durante o desenvolvimento:** compartilhar o código ajuda a editar e testar. Para distribuir o programa atualizado, construa uma nova imagem. Um bind mount também pode fornecer arquivos de configuração ao container.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker run -v "$PWD:/app" …` | monta a pasta atual em /app (bind mount) |
| `docker run -v "$PWD/site:/usr/share/nginx/html" …` | qualquer subpasta, em qualquer destino |
| `docker inspect <nome>` | em "Mounts": tipo, origem e destino de cada montagem |
| `docker exec <nome> ls /app` | o que o container vê |
| `--mount type=bind,src=…,dst=…` | a forma longa, mais explícita, do mesmo -v |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Como compartilhar arquivos com containers](https://docs.docker.com/get-started/docker-concepts/running-containers/sharing-local-files/)<small>bind mounts · em inglês</small>
- [Como usar bind mounts](https://docs.docker.com/engine/storage/bind-mounts/)
- [Comando · docker run](https://docs.docker.com/reference/cli/docker/container/run/)<small>-d, -it, --rm, --name, -p, -e, -v, --network</small>
- [Comando · docker exec](https://docs.docker.com/reference/cli/docker/container/exec/)
:::

<p class="eyebrow">Tarefa · 5 min</p>

## O desafio

:::steps
1. Construa e rode com a pasta montada:

   ```console
   $ docker build -t receitas-api:1.5 .
   $ docker run -d --name dev -p 8003:8000 -v "$PWD:/app" receitas-api:1.5
   $ curl localhost:8003/receitas
   ```

2. Execute `code app.py`. Acrescente a linha abaixo à lista `RECEITAS`, antes do `]` final, com o mesmo alinhamento das outras receitas:

   ```python
   {"nome": "Pudim", "rende": "8 porções"},
   ```

   Salve e consulte os logs. Uma mensagem com *Reloading* indica que o programa está recarregando:

   ```console
   $ docker logs dev
   ```

3. Consulte a API novamente. O Pudim deve aparecer sem você reconstruir a imagem nem reiniciar o container manualmente:

   ```console
   $ curl localhost:8003/receitas
   ```
:::

:::card Verificação
```console
$ check.sh 10
```

Confere o mount desta pasta em `/app`, o Pudim no `app.py` e na resposta da API.
:::

:::note Compare com a imagem:
`docker run --rm receitas-api:1.5 cat app.py` mostra o arquivo original, sem Pudim. Já o container `dev` acessa o arquivo atualizado da pasta compartilhada.
:::

:::card Missão extra
```console
$ docker exec dev sh -c 'echo "escrito de dentro" > /app/de-dentro.txt'
$ cat de-dentro.txt
$ rm de-dentro.txt
```

Escrito de dentro, aparece fora. É a mesma pasta.
:::
