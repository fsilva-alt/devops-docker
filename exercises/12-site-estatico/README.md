# Desafio 12 — Site estático

⏱ 5 minutos · Módulo 5: Vários containers

## Objetivo

Executar um site em um container usando o **nginx**, um servidor web: ele entrega os arquivos da página ao navegador. Os arquivos já estão prontos. Você vai criar a imagem, copiar o site para ela e publicar uma porta, como fez com a API.

## Onde

```bash
cd ~/labs/12-site-estatico
```

## Estado inicial

Uma pasta `site/` com:

| Arquivo | O quê |
|---|---|
| `index.html` | Define a estrutura da página em HTML: o título e o espaço para a lista de receitas |
| `app.js` | Código JavaScript que o navegador executa para buscar as receitas e preencher a lista |
| `receitas.json` | A lista de receitas em JSON, um formato de texto para organizar dados |
| `style.css` | Define a aparência da página, como cores, fontes e espaçamentos, usando CSS |

Neste **site estático**, o nginx entrega arquivos prontos; a lista de receitas vem de `receitas.json`. No desafio 14, o site buscará essa lista na API. Por enquanto, falta criar apenas o `Dockerfile`.

## Imagens prontas

A imagem `nginx:alpine` já traz um servidor web configurado para servir o que estiver em `/usr/share/nginx/html` na porta 80. Você só precisa colocar os seus arquivos lá. É assim com a maioria das imagens oficiais: leia a descrição no Docker Hub para saber "onde colocar as coisas".

## Tarefa

1. Execute `code Dockerfile`, copie o conteúdo abaixo para o arquivo e salve:

   ```dockerfile
   FROM nginx:alpine

   COPY site/ /usr/share/nginx/html/
   ```

   Sem `CMD`: a imagem do nginx já tem o dela (iniciar o servidor).

2. Construa e rode, ligando a porta 8080 do Codespace à 80 do container:

   ```bash
   docker build -t receitas-web:1.0 .
   docker run -d --name web -p 8080:80 receitas-web:1.0
   ```

3. Execute os comandos abaixo para consultar o HTML e os dados pelo terminal. Depois, abra a aba **PORTS**, localize a porta **8080** e clique no ícone de globo para ver a página no navegador. A lista de receitas é preenchida por `app.js`, executado pelo navegador:

   ```bash
   curl localhost:8080/
   curl localhost:8080/receitas.json
   ```

## Verificação

```bash
check.sh 12
```

## Dicas

- Ao copiar uma pasta com `COPY`, o Docker copia seu **conteúdo** para o destino. Aqui, `site/index.html` deve virar `/usr/share/nginx/html/index.html`. Se o destino terminar em `/html/site/`, a página ficará em uma subpasta, e o endereço inicial poderá continuar mostrando a página padrão do nginx.
- `docker logs web` mostra o log de acesso do nginx: uma linha por arquivo pedido pelo navegador.

## Missão extra

Edite o site sem reconstruir a imagem, como no desafio 10. Primeiro, remova o container `web` e crie outro com a pasta `site` compartilhada:

```bash
docker rm -f web
docker run -d --name web -p 8080:80 -v "$PWD/site:/usr/share/nginx/html" receitas-web:1.0
```

Abra `site/index.html` com `code site/index.html`. Troque apenas o texto entre `<h1>` e `</h1>` por `Livro de receitas da turma`, salve e recarregue a página no navegador. Mantenha a expressão `Livro de receitas` no título para que a verificação continue reconhecendo o site.
