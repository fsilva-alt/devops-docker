# Desafio 10 — Editando ao vivo

⏱ 5 minutos · Módulo 4: Dados

## Objetivo

Desenvolver dentro do container **sem reconstruir a imagem a cada mudança**: montar a pasta do projeto dentro do container com um *bind mount*, editar no VS Code e ver a API mudar na hora.

## Onde

```bash
cd ~/labs/10-editando-ao-vivo
```

## Estado inicial

A API completa (`Dockerfile` com `ENV` e `EXPOSE`). Uma diferença no `app.py`: `uvicorn.run("app:app", ..., reload=True)`, que faz o servidor reiniciar sozinho quando o arquivo muda.

## Bind mount

`-v "$PWD:/app"` diz: "dentro do container, a pasta `/app` **é** a minha pasta atual". Não é cópia: é a mesma pasta, vista dos dois lados. O que a imagem tinha em `/app` fica escondido enquanto o mount existe.

```
Codespace: ~/labs/10-editando-ao-vivo/app.py  ◀──── mesma coisa ────▶  container: /app/app.py
```

O caminho de fora precisa ser **absoluto**, por isso `$PWD`.

## Tarefa

1. Construa e rode com a pasta montada:

   ```bash
   docker build -t receitas-api:1.5 .
   docker run -d --name dev -p 8003:8000 -v "$PWD:/app" receitas-api:1.5
   curl localhost:8003/receitas
   ```

2. Abra `app.py` no VS Code e acrescente à lista `RECEITAS`:

   ```python
   {"nome": "Pudim", "rende": "8 porções"},
   ```

   Salve. Veja o uvicorn perceber a mudança:

   ```bash
   docker logs dev
   ```

   (procure por *detected changes in 'app.py'. Reloading...*).

3. Sem build, sem restart:

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
- Em produção não se faz isso: a imagem deve ser autossuficiente. Bind mount é ferramenta de **desenvolvimento**.
- Bind mount também serve para o contrário: dar ao container um arquivo de configuração que fica de fora da imagem.

## Missão extra

Crie um arquivo de dentro do container e veja-o aparecer na sua pasta:

```bash
docker exec dev sh -c 'echo "escrito de dentro" > /app/de-dentro.txt'
cat de-dentro.txt
```

Depois apague-o (`rm de-dentro.txt`), para não sujar os próximos builds.
