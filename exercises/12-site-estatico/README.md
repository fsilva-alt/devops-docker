# Desafio 12 — Site estático

⏱ 5 minutos · Módulo 5: Vários containers

## Objetivo

Colocar um site (HTML, CSS e JavaScript) num container com o **nginx**, um servidor web pronto. Mesmo fluxo do Python: `FROM` de uma imagem oficial, `COPY` dos seus arquivos, `build`, `run -p`.

## Onde

```bash
cd ~/labs/12-site-estatico
```

## Estado inicial

Uma pasta `site/` com:

| Arquivo | O quê |
|---|---|
| `index.html` | A página: um título e uma lista vazia `<ul id="receitas">` |
| `app.js` | Faz `fetch("receitas.json")` e preenche a lista |
| `receitas.json` | Os dados |
| `style.css` | Um pouco de estilo |

Não há `Dockerfile`: é você quem escreve.

## Imagens prontas

A imagem `nginx:alpine` já traz um servidor web configurado para servir o que estiver em `/usr/share/nginx/html` na porta 80. Você só precisa colocar os seus arquivos lá. É assim com a maioria das imagens oficiais: leia a descrição no Docker Hub para saber "onde colocar as coisas".

## Tarefa

1. Crie o `Dockerfile`:

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

3. Confira pelo terminal e pelo navegador (aba **PORTS** → 8080 → globo). A lista de receitas na página é preenchida pelo `app.js`; se ela aparece, o JavaScript rodou no seu navegador e o nginx serviu os três arquivos:

   ```bash
   curl localhost:8080/
   curl localhost:8080/receitas.json
   ```

## Verificação

```bash
check.sh 12
```

## Dicas

- `COPY` de uma pasta copia o **conteúdo** dela, não a pasta: `site/index.html` vira `/usr/share/nginx/html/index.html`. Se quisesse uma subpasta, teria de dizer no destino: `COPY site/ /usr/share/nginx/html/site/` (e aí o nginx não acharia o `index.html`).
- `docker logs web` mostra o log de acesso do nginx: uma linha por arquivo pedido pelo navegador.

## Missão extra

Editar o site sem reconstruir, como no desafio 10: pare o `web`, suba outro com a pasta montada por cima da do nginx e mude o `<h1>` no `index.html`:

```bash
docker rm -f web
docker run -d --name web -p 8080:80 -v "$PWD/site:/usr/share/nginx/html" receitas-web:1.0
```

Recarregue a página. (A verificação continua passando: o que importa é o `web` na 8080 servindo o site.)
