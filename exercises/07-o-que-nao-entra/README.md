# Exercício 7 — O que não entra na imagem

⏱ 4 minutos · Módulo 2: Dockerfile · **Opcional**

Pode ser feito depois da aula. O exercício 8 já traz o próprio `.dockerignore`, então dá para seguir sem fazer este agora.

## Objetivo

Nem tudo o que está na pasta do projeto precisa ir para a imagem. Você vai escolher o que fica de fora e registrar isso em um `.dockerignore`, arquivo que lista o que o Docker deve ignorar durante a construção.

## Onde

```bash
cd ~/labs/07-o-que-nao-entra
```

## Estado inicial

Além de `app.py`, `requirements.txt` e um `Dockerfile` pronto, a pasta contém arquivos de exemplo que não são necessários para executar a API:

| O quê | Por que não deveria ir |
|---|---|
| `.venv/` (3 MB) | Simula uma pasta de dependências locais do Python. Na imagem, o pip já instala as dependências necessárias |
| `__pycache__/` | Arquivos que o Python gera para reaproveitar trabalho; ele pode criá-los novamente |
| `.env` | Contém uma senha fictícia para o exercício. Tudo o que entra na imagem pode ser lido por quem tiver acesso a ela |
| `notas-pessoais.md` | Anotações suas, não do projeto |
| `fotos/` (2 MB) | Não tem nada a ver com a API |

Use `ls -A` para listar os arquivos, inclusive os que começam com ponto. `du -sh .venv fotos` mostra o espaço ocupado por essas duas pastas.

## Tarefa

1. Construa a imagem e consulte a pasta `/app` dentro de um container. Sem o `.dockerignore`, `COPY . .` inclui também os arquivos desnecessários e a senha fictícia:

   ```bash
   docker build -t receitas-api:1.2 .
   docker run --rm receitas-api:1.2 ls -A /app
   docker run --rm receitas-api:1.2 cat /app/.env
   ```

2. Execute `code .dockerignore`. Copie a lista abaixo para o arquivo, com um nome por linha, e salve. Mantenha o ponto no início do nome `.dockerignore`:

   ```
   .venv
   __pycache__
   .env
   notas-pessoais.md
   fotos
   ```

3. Construa a imagem novamente e confira se os cinco itens da lista ficaram de fora:

   ```bash
   docker build -t receitas-api:1.2 .
   docker run --rm receitas-api:1.2 ls -A /app
   ```

## Verificação

```bash
check.sh 07
```

## Dicas

- O `.dockerignore` filtra o contexto de construção, a pasta indicada pelo ponto em `docker build .`. Os arquivos listados nele não são enviados ao Docker e, por isso, não têm como ser copiados para a imagem.
- Para ver a diferença de tamanho, execute `docker images receitas-api:1.2` depois do build da etapa 1 e de novo depois do build da etapa 3, e compare a coluna `SIZE`. O segundo build reaproveita a tag; a imagem anterior fica sem nome e sai dessa lista.

## Missão extra

Acrescente também `Dockerfile` e `.dockerignore` ao `.dockerignore`. Esses arquivos servem para construir a imagem e não precisam estar dentro dela. Construa de novo e confira com `ls -A /app`.
