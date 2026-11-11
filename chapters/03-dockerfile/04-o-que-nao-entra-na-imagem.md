---
duration: 4
---

# O que não entra na imagem

{.lead}
Escolher quais arquivos do projeto ficam **fora da imagem** e registrar essa escolha em um `.dockerignore`, um arquivo de texto com a lista do que o Docker deve ignorar na construção.

`.dockerignore` `docker build` `docker run --rm <img> ls -A /app`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/07-o-que-nao-entra
```

Além da API, a pasta tem arquivos de exemplo de que ela não precisa, como fotos e uma senha fictícia. `ls -A` lista também os arquivos que começam com ponto, e `du -sh .venv fotos` mostra o tamanho dessas duas pastas.
:::
:::card Para este exercício
`⏱ tempo`
: 4 min · pode ficar para depois da aula

`parte`
: Dockerfile

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
| `.venv` | simula uma pasta de dependências locais do Python; na imagem, o pip já instala o que é preciso |
| `__pycache__` | arquivos que o Python gera sozinho e pode criar de novo |
| `.env` | contém uma senha fictícia; tudo o que entra na imagem pode ser lido por quem tem acesso a ela |
| `notas-pessoais.md` | anotações suas, não do projeto |
| `fotos` | não são usadas pela API e aumentam o tamanho da imagem |
:::
::::
::::column
:::card O que a API precisa para rodar?
Só do código e das dependências que o pip instala. As anotações, as fotos e os arquivos temporários não fazem parte do programa.

O `.dockerignore` deixa esses itens fora da cópia, sem apagá-los da pasta do Codespace.
:::

:::note Um nome por linha.
Crie o arquivo na mesma pasta do Dockerfile e liste nele arquivos e pastas, um por linha. O filtro vale para toda a pasta do projeto.
:::
::::
:::::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `.dockerignore` | arquivo na pasta do projeto; lista os itens que devem ficar fora da imagem |
| `docker run --rm <img> ls -A /app` | lista os arquivos copiados para /app, inclusive os que começam com ponto |
| `docker images <nome>` | mostra o tamanho de cada tag |
| `docker build --progress=plain .` | mostra "transferring context: X MB": quanto foi enviado ao daemon |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Contexto de construção e .dockerignore](https://docs.docker.com/build/concepts/context/#dockerignore-files)<small>em inglês</small>
- [Recomendações para construir imagens](https://docs.docker.com/build/building/best-practices/)<small>ordem das instruções, .dockerignore e tamanho · em inglês</small>
- [Como escrever um Dockerfile](https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/)<small>em inglês</small>
:::

<p class="eyebrow">Tarefa · 4 min · pode ficar para depois da aula</p>

## O exercício

:::steps
1. Construa a imagem e liste os arquivos de `/app`. Sem o `.dockerignore`, o `COPY . .` leva também os arquivos desnecessários e a senha fictícia:

   ```console
   $ docker build -t receitas-api:1.2 .
   $ docker run --rm receitas-api:1.2 ls -A /app
   $ docker run --rm receitas-api:1.2 cat /app/.env
   ```

2. Rode `code .dockerignore`, copie a lista abaixo para o arquivo e salve. O nome do arquivo começa com um ponto:

   ```text
   .venv
   __pycache__
   .env
   notas-pessoais.md
   fotos
   ```

3. Construa de novo e confira se os cinco itens ficaram fora da imagem:

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

A verificação lista `/app` dentro da imagem e reprova se algum dos cinco itens estiver lá.
:::
:::card Missão extra
Acrescente também `Dockerfile` e `.dockerignore` ao `.dockerignore`. Esses arquivos servem para construir a imagem e não precisam estar dentro dela. Construa de novo e confira com `ls -A /app`.
:::
::::

:::warning
**Se faltar tempo:** este exercício pode ficar para depois da aula. O intervalo vem logo depois deste bloco.
:::
