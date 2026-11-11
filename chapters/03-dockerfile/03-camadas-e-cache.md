---
duration: 5
---

# Camadas e cache

{.lead}
Organizar o Dockerfile para que uma alteração no código **não obrigue o Docker a reinstalar as dependências**. O reaproveitamento de etapas já construídas é chamado de **cache**.

`COPY requirements.txt .` `RUN pip install` `COPY . .` `docker history`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/06-camadas-e-cache
```

`app.py`, `requirements.txt` e um `Dockerfile` igual ao do exercício 5, com `COPY . .` **antes** do `pip install`.
:::
:::card Para este exercício
`⏱ tempo`
: 5 min

`parte`
: Dockerfile

`verificação`
: `check.sh 06`
:::
::::

<p class="eyebrow">Conceito · camadas e cache</p>

## O que precisa ser construído de novo?

::::columns
:::column
<div class="layers"><div class="cap">código copiado antes: alterar app.py também refaz a instalação</div><div class="stk"><div class="layer dim"><b>CMD ["python", "app.py"]</b></div><div class="layer "><b>RUN pip install …</b><span class="tg redo">REFAZ</span><small>instala as dependências novamente</small></div><div class="layer hi"><b>COPY . .</b><span class="tg redo">REFAZ</span><small>app.py mudou → camada nova</small></div><div class="layer "><b>WORKDIR /app</b><span class="tg ok">CACHED</span></div><div class="layer "><b>FROM python:3.12-slim</b><span class="tg ok">CACHED</span></div></div></div>
:::
:::column
<div class="layers"><div class="cap">código copiado depois: a instalação pode ser reutilizada</div><div class="stk"><div class="layer dim"><b>CMD ["python", "app.py"]</b></div><div class="layer hi"><b>COPY . .</b><span class="tg redo">REFAZ</span><small>app.py mudou → camada nova</small></div><div class="layer "><b>RUN pip install …</b><span class="tg ok">CACHED</span><small>as etapas anteriores não mudaram</small></div><div class="layer "><b>COPY requirements.txt .</b><span class="tg ok">CACHED</span><small>mesmo arquivo</small></div><div class="layer "><b>WORKDIR /app</b><span class="tg ok">CACHED</span></div><div class="layer "><b>FROM python:3.12-slim</b><span class="tg ok">CACHED</span></div></div></div>
:::
::::

::::columns
:::card O que significa CACHED?
A imagem é formada por **camadas**, que guardam as alterações nos arquivos. Se uma instrução e os arquivos que ela usa continuam iguais, o Docker reaproveita o resultado da construção anterior e mostra `CACHED`. Quando uma etapa muda, as seguintes também são refeitas.
:::
:::card Como organizar o Dockerfile
Copie primeiro `requirements.txt` e instale as dependências. Depois, copie o código. Assim, editar uma receita em `app.py` não obriga o Docker a repetir a instalação.

Algumas instruções, como `CMD`, só guardam uma configuração e não acrescentam arquivos.
:::
::::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker history <imagem>` | mostra as camadas, com a instrução e o tamanho de cada uma |
| `docker build --no-cache …` | ignora o cache e refaz tudo |
| `docker build --progress=plain …` | saída completa, sem redesenhar a tela |
| `COPY requirements.txt .` | copie primeiro o que muda menos |
| `docker system df` | quanto disco o cache de build ocupa (exercício 18) |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Como funcionam as camadas de uma imagem](https://docs.docker.com/get-started/docker-concepts/building-images/understanding-image-layers/)<small>em inglês</small>
- [Como reutilizar etapas da construção: cache](https://docs.docker.com/get-started/docker-concepts/building-images/using-the-build-cache/)<small>em inglês</small>
- [Cache de construção de imagens](https://docs.docker.com/build/cache/)<small>em inglês</small>
- [Recomendações para construir imagens](https://docs.docker.com/build/building/best-practices/)<small>ordem das instruções, .dockerignore e tamanho · em inglês</small>
- [Comando · docker history](https://docs.docker.com/reference/cli/docker/image/history/)
:::

<p class="eyebrow">Tarefa · 5 min</p>

## O exercício

:::steps
1. Construa a imagem uma primeira vez:

   ```console
   $ docker build -t receitas-api:1.1 .
   ```

2. Abra `app.py` com `code app.py`. Na lista `RECEITAS = [`, acrescente a linha abaixo antes do `]` final, alinhada às outras receitas:

   ```python
   {"nome": "Mousse de maracujá", "rende": "6 porções"},
   ```

   Salve e construa de novo. O `pip install` roda outra vez, mesmo sem nenhuma mudança na lista de dependências:

   ```console
   $ docker build -t receitas-api:1.1 .
   ```

3. No Dockerfile, troque as linhas `COPY . .` e `RUN pip install…` pelo trecho abaixo. Deixe `FROM`, `WORKDIR` e `CMD` como estão:

   ```dockerfile
   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt

   COPY . .
   ```

4. Salve o Dockerfile e construa a imagem. Depois, troque `Mousse de maracujá` por `Mousse de limão` em `app.py`, salve e construa de novo. A etapa do pip deve aparecer como `CACHED`:

   ```console
   $ docker build -t receitas-api:1.1 .
   ```

   Agora edite e salve o `app.py`. Depois, construa de novo:

   ```console
   $ docker build -t receitas-api:1.1 .
   ```

5. Veja o histórico da imagem, com a instrução e o tamanho de cada etapa:

   ```console
   $ docker history receitas-api:1.1
   ```
:::

:::card Verificação
```console
$ check.sh 06
```

Aprova quando o Dockerfile está na ordem certa, o `app.py` foi alterado e a imagem contém a versão atual dele.
:::

:::note
**O que observar:** procure `CACHED` na etapa `RUN pip install`. Como o instalador do curso já preparou parte do cache, o `CACHED` pode aparecer logo na primeira construção com a nova ordem.
:::

:::card Missão extra
```console
$ time docker build --no-cache -t receitas-api:1.1 .
$ time docker build -t receitas-api:1.1 .
```

`time` mede a duração de um comando. Compare o valor de `real` na construção sem cache e na construção seguinte.
:::
