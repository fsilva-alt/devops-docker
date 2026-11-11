---
duration: 5
---

# Site estático

{.lead}
Colocar um site no ar em um container com o **nginx**, um servidor web que entrega os arquivos da página ao navegador. O site já está pronto. Falta montar uma imagem com ele e publicar uma porta, como você fez com a API.

`FROM nginx:alpine` `COPY site/ /usr/share/nginx/html/` `docker run -d -p 8080:80` `curl localhost:8080/`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/15-site-estatico
```

A pasta `site/` tem a página, o estilo dela, o código que preenche a lista e os dados das receitas. Só falta o Dockerfile.
:::
:::card Para este exercício
`⏱ tempo`
: 5 min

`parte`
: Vários containers

`verificação`
: `check.sh 15`
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
| `receitas.json` | JSON: guarda o nome de cada receita e quanto ela rende |
:::

:::note Por que estático?
Porque o nginx só entrega arquivos prontos. Neste exercício, as receitas vêm do arquivo `receitas.json`. No exercício 17, o site passa a buscar a lista na API. O JavaScript roda no navegador, e não no container.
:::

:::note A imagem já está configurada.
A imagem `nginx:alpine` já inicia o servidor e entrega o que estiver em `/usr/share/nginx/html` pela porta 80. Você só precisa copiar o site para essa pasta. Não é preciso `CMD`, porque a imagem do nginx já tem o dela.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `FROM nginx:alpine` | parte da imagem que já tem o servidor nginx |
| `COPY site/ /usr/share/nginx/html/` | copia os arquivos do site para a pasta usada pelo nginx |
| `docker run -d --name web -p 8080:80 …` | liga a porta 8080 do Codespace à porta 80 do nginx |
| `docker logs web` | mostra o log de acesso, com uma linha por requisição |
| `docker exec web ls /usr/share/nginx/html` | lista os arquivos copiados para a pasta do nginx |

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

## O exercício

:::steps
1. Rode `code Dockerfile`, copie o conteúdo abaixo para o arquivo e salve:

   ```dockerfile
   FROM nginx:alpine

   COPY site/ /usr/share/nginx/html/
   ```

2. Construa a imagem e rode o container, ligando a porta 8080 do Codespace à 80 do container:

   ```console
   $ docker build -t receitas-web:1.0 .
   $ docker run -d --name web -p 8080:80 receitas-web:1.0
   ```

3. Teste pelo terminal. Depois, na aba **PORTS**, abra a porta 8080 pelo ícone de globo para ver a página. Quem preenche a lista de receitas é o `app.js`, que roda no navegador.

   ```console
   $ curl localhost:8080/
   $ curl localhost:8080/receitas.json
   ```
:::

:::card Verificação
```console
$ check.sh 15
```

Confere o `FROM nginx`, o container `web` na porta 8080 e se a página, o `app.js` e o `receitas.json` respondem.
:::

:::note Confira o destino do COPY.
O `COPY` copia o conteúdo da pasta, então `site/index.html` vira `/usr/share/nginx/html/index.html`. Se o destino terminar em `/html/site/`, o site fica em uma subpasta, e o endereço inicial continua mostrando a página padrão do nginx.
:::

:::card Missão extra · editar ao vivo
```console
$ docker rm -f web
$ docker run -d --name web -p 8080:80 -v "$PWD/site:/usr/share/nginx/html" receitas-web:1.0
```

Esses comandos recriam o container `web` com a pasta `site` compartilhada, como no exercício 11. Abra `site/index.html` no editor, troque o texto entre `<h1>` e `</h1>` por `Livro de receitas da turma`, salve e recarregue a página. Mantenha as palavras `Livro de receitas` no título, para a verificação continuar reconhecendo o site.
:::
