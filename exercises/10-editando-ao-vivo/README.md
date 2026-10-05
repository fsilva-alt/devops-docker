# Exercício 10 — Editando ao vivo

⏱ 5 minutos · Módulo 4: Dados · **Trilha principal**

Faça depois do 9. O compartilhamento de pastas volta a aparecer nos exercícios do site e da comunicação entre containers.

## Objetivo

Aqui a API passa a ler o código direto da sua pasta: você altera o programa no VS Code e vê a mudança sem reconstruir a imagem. Isso é feito com um **bind mount**, que compartilha a pasta do projeto com o container.

## Onde

```bash
cd ~/labs/10-editando-ao-vivo
```

## Estado inicial

A API completa, com `ENV` e `EXPOSE` no `Dockerfile`. A diferença está no `app.py`, que chama `uvicorn.run("app:app", ..., reload=True)`. O `reload=True` faz o servidor reiniciar sozinho quando o arquivo muda.

## Bind mount

Um bind mount torna uma pasta do Codespace acessível dentro do container. Em `-v "$PWD:/app"`, `$PWD` representa o caminho completo da pasta atual, e `/app` é o caminho pelo qual o container acessa essa pasta. O Codespace e o container veem os mesmos arquivos; nada é copiado. Enquanto essa montagem estiver ativa, os arquivos originais da imagem em `/app` ficam ocultos.

```
Codespace: ~/labs/10-editando-ao-vivo/app.py  ◀──── mesma coisa ────▶  container: /app/app.py
```

O caminho do Codespace precisa ser **absoluto**, isto é, começar na raiz `/`. `$PWD` já entrega um caminho absoluto, mas é o da pasta em que você está; por isso, entre na pasta do exercício antes de executar o comando.

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

   Procure uma mensagem como *detected changes in 'app.py'. Reloading...*. Ela mostra que o uvicorn percebeu a alteração e está recarregando o programa.

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

- A imagem `receitas-api:1.5` não mudou: `docker run --rm receitas-api:1.5 cat app.py` ainda mostra o arquivo sem o Pudim. O container `dev` lê a sua pasta, não a imagem.
- Compartilhar o código dessa forma é útil durante o desenvolvimento, quando você está editando e testando o programa. Para distribuir essa versão a outras pessoas, construa uma nova imagem com o código atualizado.
- Um bind mount também pode disponibilizar um arquivo de configuração que está fora da imagem.

## Missão extra

Crie um arquivo de dentro do container e veja-o aparecer na sua pasta:

```bash
docker exec dev sh -c 'echo "escrito de dentro" > /app/de-dentro.txt'
cat de-dentro.txt
```

Depois, remova o arquivo de teste com `rm de-dentro.txt`, para que ele não seja incluído em futuras construções da imagem.
