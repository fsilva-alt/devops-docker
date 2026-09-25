# Desafio 10 — Editando ao vivo

⏱ 5 minutos · Módulo 4: Dados

## Objetivo

Alterar o programa no VS Code e ver a mudança na API **sem reconstruir a imagem**. Para isso, você vai compartilhar a pasta do projeto com o container usando um **bind mount**.

## Onde

```bash
cd ~/labs/10-editando-ao-vivo
```

## Estado inicial

A API completa (`Dockerfile` com `ENV` e `EXPOSE`). Uma diferença no `app.py`: `uvicorn.run("app:app", ..., reload=True)`, que faz o servidor reiniciar sozinho quando o arquivo muda.

## Bind mount

Um **bind mount** torna uma pasta do Codespace acessível dentro do container. Em `-v "$PWD:/app"`, `$PWD` representa o caminho completo da pasta atual, e `/app` é o caminho pelo qual o container acessa essa pasta. Os dois acessam os mesmos arquivos, sem criar uma cópia. Enquanto essa montagem estiver ativa, os arquivos originais da imagem em `/app` ficam ocultos.

```
Codespace: ~/labs/10-editando-ao-vivo/app.py  ◀──── mesma coisa ────▶  container: /app/app.py
```

O caminho do Codespace precisa ser **absoluto**, isto é, começar na raiz `/`. `$PWD` já fornece esse caminho; por isso, entre na pasta do desafio antes de executar o comando.

## Tarefa

1. Construa e rode com a pasta montada:

   ```bash
   docker build -t receitas-api:1.5 .
   docker run -d --name dev -p 8003:8000 -v "$PWD:/app" receitas-api:1.5
   curl localhost:8003/receitas
   ```

2. Execute `code app.py`. Procure a lista que começa com `RECEITAS = [` e acrescente a linha abaixo antes do `]` que fecha a lista. Mantenha o alinhamento das outras receitas e a vírgula final:

   ```python
   {"nome": "Pudim", "rende": "8 porções"},
   ```

   Salve com **Ctrl+S** ou **Cmd+S** no Mac. Depois, consulte os logs:

   ```bash
   docker logs dev
   ```

   Procure uma mensagem como *detected changes in 'app.py'. Reloading...*, que indica que o uvicorn detectou a alteração e está recarregando o programa.

3. Consulte a API novamente. Você não precisa reconstruir a imagem nem reiniciar o container manualmente:

   ```bash
   curl localhost:8003/receitas
   ```

   O Pudim está lá.

## Verificação

```bash
check.sh 10
```

## Dicas

- A imagem `receitas-api:1.5` **não mudou**: `docker run --rm receitas-api:1.5 cat app.py` ainda não tem o Pudim. O container `dev` lê a sua pasta, não a imagem.
- Compartilhar o código dessa forma é útil durante o desenvolvimento, quando você está editando e testando o programa. Para distribuir essa versão a outras pessoas, construa uma nova imagem com o código atualizado.
- Um bind mount também pode disponibilizar um arquivo de configuração que está fora da imagem.

## Missão extra

Crie um arquivo de dentro do container e veja-o aparecer na sua pasta:

```bash
docker exec dev sh -c 'echo "escrito de dentro" > /app/de-dentro.txt'
cat de-dentro.txt
```

Depois, remova o arquivo de teste com `rm de-dentro.txt`, para que ele não seja incluído em futuras construções da imagem.
