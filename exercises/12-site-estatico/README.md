# Exercício 12 — Site estático

⏱ 5 minutos · Módulo 5: Vários containers

## Objetivo

Colocar um site no ar dentro de um container com o **nginx**, um servidor web que entrega os arquivos da página ao navegador. Os arquivos do site já estão prontos. O seu trabalho é montar uma imagem com eles e publicar uma porta, como você fez com a API.

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

Em um **site estático**, o nginx só entrega arquivos prontos; aqui, a lista de receitas vem de `receitas.json`. No exercício 14, o site passará a buscar essa lista na API. Na pasta, só falta o `Dockerfile`.

## Imagens prontas

A imagem `nginx:alpine` já traz um servidor web configurado para servir o que estiver em `/usr/share/nginx/html` na porta 80. Você só precisa colocar os seus arquivos lá. A maioria das imagens oficiais funciona assim, e a descrição de cada uma no Docker Hub diz onde colocar os arquivos e as configurações.

## Tarefa

1. Execute `code Dockerfile`, copie o conteúdo abaixo para o arquivo e salve:

   ```dockerfile
   FROM nginx:alpine

   COPY site/ /usr/share/nginx/html/
   ```

   Não é preciso `CMD`, porque a imagem do nginx já tem o dela, que inicia o servidor.

2. Construa e rode, ligando a porta 8080 do Codespace à 80 do container:

   ```bash
   docker build -t receitas-web:1.0 .
   docker run -d --name web -p 8080:80 receitas-web:1.0
   ```

3. Consulte o HTML e os dados pelo terminal:

   ```bash
   curl localhost:8080/
   curl localhost:8080/receitas.json
   ```

   Depois, abra a aba **PORTS**, localize a porta 8080 e clique no ícone de globo para ver a página no navegador. Quem preenche a lista de receitas é o `app.js`, executado pelo navegador.

## Verificação

```bash
check.sh 12
```

## Dicas

- Ao copiar uma pasta com `COPY`, o Docker copia seu **conteúdo** para o destino. Aqui, `site/index.html` deve virar `/usr/share/nginx/html/index.html`. Se o destino terminar em `/html/site/`, a página ficará em uma subpasta, e o endereço inicial poderá continuar mostrando a página padrão do nginx.
- `docker logs web` mostra o log de acesso do nginx: uma linha por arquivo pedido pelo navegador.

## Missão extra

Edite o site sem reconstruir a imagem, como no exercício 10. Primeiro, remova o container `web` e crie outro com a pasta `site` compartilhada:

```bash
docker rm -f web
docker run -d --name web -p 8080:80 -v "$PWD/site:/usr/share/nginx/html" receitas-web:1.0
```

Abra `site/index.html` com `code site/index.html`. Troque apenas o texto entre `<h1>` e `</h1>` por `Livro de receitas da turma`, salve e recarregue a página no navegador. Mantenha a expressão `Livro de receitas` no título para que a verificação continue reconhecendo o site.
