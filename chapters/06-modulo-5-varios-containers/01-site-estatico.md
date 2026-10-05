---
duration: 5
---

# Site estático

{.lead}
Executar um site em um container usando o **nginx**, um servidor web que entrega os arquivos da página ao navegador. O site está pronto; você vai criar a imagem e publicar uma porta para acessá-lo.

`FROM nginx:alpine` `COPY site/ /usr/share/nginx/html/` `docker run -d -p 8080:80` `curl localhost:8080/`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/12-site-estatico
```

A pasta `site/` contém a página, sua aparência, o código que preenche a lista e os dados das receitas. Falta criar o Dockerfile.
:::
:::card Para este desafio
`⏱ tempo`
: 5 min

`módulo`
: Módulo 5 · Vários containers

`verificação`
: `check.sh 12`
:::
::::

<p class="eyebrow">Conceito · site estático e nginx</p>

## Quais arquivos formam o site?

<div class="flow"><div class="node"><b>site/</b><small>index.html · app.js · receitas.json · style.css</small></div><div class="arr"><span class="a">→</span>COPY site/ /usr/share/nginx/html/</div><div class="node hi"><b>nginx:alpine</b><small>entrega os arquivos da pasta pela porta 80</small></div><div class="arr"><span class="a">→</span>-p 8080:80</div><div class="node"><b>navegador</b><small>exibe a página e executa o JavaScript que busca as receitas</small></div></div>

:::card O papel de cada arquivo
| Arquivo | Função |
| --- | --- |
| `index.html` | HTML: define a estrutura da página, com título e espaço para a lista |
| `style.css` | CSS: define cores, fontes e espaçamentos |
| `app.js` | JavaScript: busca os dados e preenche a lista no navegador |
| `receitas.json` | JSON: guarda os nomes das receitas e suas quantidades |
:::

:::note Por que estático?
O nginx entrega arquivos prontos. Neste desafio, as receitas vêm do arquivo `receitas.json`; no desafio 14, virão da API. O JavaScript é executado no navegador, não no container.
:::

:::note A imagem já está configurada.
`nginx:alpine` inicia o servidor e entrega os arquivos de `/usr/share/nginx/html` pela porta 80. Por isso, basta copiar o site para essa pasta; não precisamos definir outro `CMD`.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `FROM nginx:alpine` | usa a imagem que já contém o servidor nginx |
| `COPY site/ /usr/share/nginx/html/` | copia os arquivos do site para a pasta usada pelo nginx |
| `docker run -d --name web -p 8080:80 …` | liga a porta 8080 do Codespace à porta 80 do nginx |
| `docker logs web` | o log de acesso: uma linha por requisição |
| `docker exec web ls /usr/share/nginx/html` | conferir o que chegou lá |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Docker Hub · nginx](https://hub.docker.com/_/nginx)<small>onde colocar os arquivos do site</small>
- [Onde as imagens são publicadas?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-registry/)<small>Docker Hub e outros registros · em inglês</small>
- [Dockerfile · COPY](https://docs.docker.com/reference/dockerfile/#copy)
- [Comando · docker logs](https://docs.docker.com/reference/cli/docker/container/logs/)<small>-f, --tail</small>
- [GitHub Docs · Encaminhar portas no Codespace](https://docs.github.com/pt/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace)<small>a aba PORTS · pt-br</small>
:::

<p class="eyebrow">Tarefa · 5 min</p>

## O desafio

:::steps
1. Execute `code Dockerfile`, copie o conteúdo abaixo para o arquivo e salve:

   ```dockerfile
   FROM nginx:alpine

   COPY site/ /usr/share/nginx/html/
   ```

2. Construa e rode, ligando a 8080 do Codespace à 80 do container:

   ```console
   $ docker build -t receitas-web:1.0 .
   $ docker run -d --name web -p 8080:80 receitas-web:1.0
   ```

3. Pelo terminal e pelo navegador (aba **PORTS** → 8080 → globo). A lista de receitas na página é preenchida pelo `app.js`.

   ```console
   $ curl localhost:8080/
   $ curl localhost:8080/receitas.json
   ```
:::

:::card Verificação
```console
$ check.sh 12
```

Confere o `FROM nginx`, o `web` na 8080 e que HTML, `app.js` e `receitas.json` respondem.
:::

:::note Confira o destino do COPY.
O comando copia o conteúdo da pasta: `site/index.html` deve virar `/usr/share/nginx/html/index.html`. Se o destino terminar em `/html/site/`, o site ficará em uma subpasta, e o endereço inicial poderá mostrar a página padrão do nginx.
:::

:::card Missão extra · editar ao vivo
```console
$ docker rm -f web
$ docker run -d --name web -p 8080:80 -v "$PWD/site:/usr/share/nginx/html" receitas-web:1.0
```

Abra `site/index.html` no editor. Troque o texto entre `<h1>` e `</h1>` por `Livro de receitas da turma`, salve e recarregue a página. Mantenha a expressão `Livro de receitas` para a verificação reconhecer o site.
:::
