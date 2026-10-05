---
duration: 4
---

# O que não entra na imagem

{.lead}
Escolher quais arquivos do projeto devem ficar **fora da imagem**. Você vai criar um `.dockerignore`, um arquivo de texto com a lista do que o Docker deve ignorar.

`.dockerignore` `docker build` `docker run --rm <img> ls -A /app`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/07-o-que-nao-entra
```

A pasta inclui arquivos de exemplo que a API não precisa, como fotos e uma senha fictícia. `ls -A` lista também os arquivos que começam com ponto; `du -sh .venv fotos` mostra o tamanho dessas pastas.
:::
:::card Para este desafio
`⏱ tempo`
: 4 min · pode ficar para depois da aula

`módulo`
: Módulo 2 · Dockerfile

`verificação`
: `check.sh 07`
:::
::::

<p class="eyebrow">Conceito</p>

## O contexto passa por um filtro

<div class="flow"><div class="node"><b>a pasta (contexto)</b><small>app.py · requirements.txt · .venv · .env · fotos…</small></div><div class="arr"><span class="a">→</span>filtro<br><strong>.dockerignore</strong></div><div class="node hi"><b>arquivos disponíveis para cópia</b><small>os itens listados no .dockerignore ficam de fora</small></div><div class="arr"><span class="a">→</span>COPY . .</div><div class="node"><b>imagem</b><small>sem os arquivos excluídos pelo filtro</small></div></div>

:::::columns
::::column
:::card
| Padrão | Por que fica de fora |
| --- | --- |
| `.venv` | simula dependências locais do Python; na imagem, o pip já instala o necessário |
| `__pycache__` | arquivos gerados automaticamente pelo Python, que podem ser recriados |
| `.env` | contém uma senha fictícia; arquivos na imagem podem ser lidos por quem tem acesso a ela |
| `notas-pessoais.md` | anotações suas, não do projeto |
| `fotos` | não são usadas pela API e aumentam o tamanho da imagem |
:::
::::
::::column
:::card O que a API precisa para executar?
Neste exercício, ela precisa do código e das dependências instaladas pelo pip. As anotações pessoais, as fotos e os arquivos temporários não fazem parte do programa.

O `.dockerignore` exclui esses itens da cópia sem apagá-los da pasta do Codespace.
:::

:::note Um nome por linha.
Crie o arquivo na mesma pasta do Dockerfile. Você pode listar arquivos e pastas. O filtro vale para todo o contexto de construção.
:::
::::
:::::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `.dockerignore` | arquivo na pasta do projeto; lista os itens que devem ficar fora da imagem |
| `docker run --rm <img> ls -A /app` | lista os arquivos copiados para /app, inclusive os que começam com ponto |
| `docker images <nome>` | tamanhos de cada tag |
| `docker build --progress=plain .` | mostra "transferring context: X MB": quanto foi enviado ao daemon |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Contexto de construção e .dockerignore](https://docs.docker.com/build/concepts/context/#dockerignore-files)<small>em inglês</small>
- [Recomendações para construir imagens](https://docs.docker.com/build/building/best-practices/)<small>ordem das instruções, .dockerignore e tamanho · em inglês</small>
- [Como escrever um Dockerfile](https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/)<small>em inglês</small>
:::

<p class="eyebrow">Tarefa · 4 min · pode ficar para depois da aula</p>

## O desafio

:::steps
1. Construa a imagem e liste os arquivos em `/app`. Sem o filtro, a senha fictícia também é copiada:

   ```console
   $ docker build -t receitas-api:1.2 .
   $ docker run --rm receitas-api:1.2 ls -A /app
   $ docker run --rm receitas-api:1.2 cat /app/.env
   ```

2. Execute `code .dockerignore`, copie a lista abaixo para o arquivo e salve:

   ```text
   .venv
   __pycache__
   .env
   notas-pessoais.md
   fotos
   ```

3. Construa novamente e confira se os cinco itens ficaram fora da imagem:

   ```console
   $ docker build -t receitas-api:1.2 .
   $ docker run --rm receitas-api:1.2 ls -A /app
   ```
:::

::::columns
:::card Verificação
```console
$ check.sh 07
```

Lista `/app` dentro da imagem e reprova se algum dos cinco estiver lá.
:::
:::card Missão extra
Inclua também `Dockerfile` e `.dockerignore` no `.dockerignore`: servem para construir a imagem, não precisam estar dentro dela. Compare os tamanhos com `docker images receitas-api`.
:::
::::

:::warning
**Se faltar tempo:** este desafio pode ser feito depois da aula. O intervalo está previsto para o fim deste bloco.
:::
