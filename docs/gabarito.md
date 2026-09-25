# Gabarito

Soluções para consultar durante a preparação da aula ou ao revisar os exercícios. Os enunciados explicam cada etapa; aqui estão os arquivos e comandos necessários. A versão executável, usada pelos testes, está em `tests/solucoes.sh`.

## Como usar

- Nos desafios 4 a 14, entre primeiro na pasta indicada na seção **Onde** do enunciado. O comando `cd` muda a pasta do terminal. Os outros desafios podem ser feitos em qualquer pasta.
- Execute os comandos de terminal um por vez. Copie os blocos de Dockerfile e YAML para o arquivo indicado, usando o editor, e salve antes de continuar.
- Ao terminar, execute `check.sh` com o número do desafio, como `check.sh 05`. Os nomes de imagens, containers e arquivos devem ser os mesmos dos exemplos.

## Desafio 0 — Docker funciona?

```bash
docker version
docker run hello-world
docker compose version
```

## Desafio 1 — Olá, container

```bash
docker run hello-world
docker run python:3.12-slim python -c "print('Olá, Docker!')"
docker ps
docker ps -a
docker images
```

## Desafio 2 — Dentro do container

No terminal do Codespace, abra o Python interativo:

```bash
docker run -it --rm python:3.12-slim
```

Quando aparecer `>>>`, digite `exit()` para sair. De volta ao Codespace, abra o Bash em outro container:

```bash
docker run -it --name explorador python:3.12-slim bash
```

Agora, dentro do container:

```bash
cat /etc/os-release
ls /
echo "eu estive aqui" > /marca.txt
exit
```

De volta ao Codespace, tente ler a marca em um novo container:

```bash
docker run --rm python:3.12-slim cat /marca.txt
```

O erro *No such file or directory* é esperado: esse container não tem o arquivo criado em `explorador`. Se faltou `--rm` na primeira etapa, consulte `docker ps -a` e remova apenas o container do Python interativo com `docker rm <id>`, substituindo `<id>` pelo identificador dele.

## Desafio 3 — Ciclo de vida

```bash
docker run -d --name relogio alpine sh -c 'while true; do date; sleep 1; done'
docker logs relogio
docker stop relogio                           # demora ~10 s: o sh ignora o SIGTERM
docker start relogio
docker run -d --name descartavel alpine sleep 600
docker rm descartavel                         # erro: está rodando
docker rm -f descartavel
```

## Desafio 4 — Meu primeiro Dockerfile

Na pasta do desafio, execute `code Dockerfile`, copie este conteúdo e salve:

```dockerfile
FROM python:3.12-slim
COPY receitas.py /app/receitas.py
CMD ["python", "/app/receitas.py"]
```

```bash
docker build -t receitas:1.0 .
docker run --rm receitas:1.0
docker tag receitas:1.0 receitas:latest       # missão extra
```

## Desafio 5 — Instalando dependências

Crie e salve o `Dockerfile` com este conteúdo:

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "app.py"]
```

```bash
docker build -t receitas-api:1.0 .
docker run --rm receitas-api:1.0 pip list
```

## Desafio 6 — Camadas e cache

1. Construa com `docker build -t receitas-api:1.1 .`.
2. Em `app.py`, acrescente `{"nome": "Mousse de maracujá", "rende": "6 porções"},` antes do `]` que fecha a lista `RECEITAS`. Mantenha o alinhamento das outras receitas, salve e repita a construção. O pip será executado novamente.
3. Substitua o conteúdo do `Dockerfile` pelo exemplo abaixo e salve:

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

4. Execute `docker build -t receitas-api:1.1 .` com a nova ordem. Depois, troque `Mousse de maracujá` por `Mousse de limão` em `app.py`, salve e repita o comando. A etapa do pip deve aparecer como `CACHED`. Consulte o histórico com `docker history receitas-api:1.1`.

A verificação exige o `app.py` diferente do original **e** igual ao que está dentro da imagem.

## Desafio 7 — O que não entra na imagem

Crie o arquivo `.dockerignore` no editor, com um nome por linha, e salve:

```text
.venv
__pycache__
.env
notas-pessoais.md
fotos
```

Depois, construa a imagem e confira os arquivos:

```bash
docker build -t receitas-api:1.2 .
docker run --rm receitas-api:1.2 ls -A /app
```

## Desafio 8 — Abrindo portas

Acrescente `EXPOSE 8000` antes de `CMD` no Dockerfile, salve e execute:

```bash
docker build -t receitas-api:1.3 .
docker run -d --name api -p 8001:8000 receitas-api:1.3
curl localhost:8001/receitas
```

Na aba **PORTS**, localize a porta **8001** e clique no ícone de globo para abrir o navegador. Acrescente `/docs` ao endereço para consultar e testar as rotas da API.

## Desafio 9 — Configuração por ambiente

Acrescente `ENV COZINHA="Cozinha do Curso"` antes de `EXPOSE` no Dockerfile, salve e execute:

```bash
docker build -t receitas-api:1.4 .
docker run -d --name cozinha -p 8002:8000 -e COZINHA="Cozinha da Ana" receitas-api:1.4
curl localhost:8002/
```

Missão extra: leia `cozinha.env` com `cat cozinha.env` e recrie o container usando esse arquivo:

```bash
docker rm -f cozinha
docker run -d --name cozinha -p 8002:8000 --env-file cozinha.env receitas-api:1.4
curl localhost:8002/
```

## Desafio 10 — Editando ao vivo

```bash
docker build -t receitas-api:1.5 .
docker run -d --name dev -p 8003:8000 -v "$PWD:/app" receitas-api:1.5
```

Abra `app.py` no editor e acrescente a linha abaixo antes do `]` que fecha a lista `RECEITAS`, mantendo o alinhamento das outras receitas:

```python
{"nome": "Pudim", "rende": "8 porções"},
```

Salve o arquivo e consulte a API no terminal:

```bash
curl localhost:8003/receitas
```

## Desafio 11 — Dados que ficam

```bash
docker build -t bloco:1.0 .
docker run --rm bloco:1.0 "comprar cenouras"
docker run --rm bloco:1.0 "assar o bolo"      # só uma nota: o primeiro container foi removido
docker volume create notas
docker run --rm -v notas:/dados bloco:1.0 "comprar cenouras"
docker run --rm -v notas:/dados bloco:1.0 "assar o bolo"
```

## Desafio 12 — Site estático

Crie e salve o `Dockerfile` com este conteúdo:

```dockerfile
FROM nginx:alpine
COPY site/ /usr/share/nginx/html/
```

```bash
docker build -t receitas-web:1.0 .
docker run -d --name web -p 8080:80 receitas-web:1.0
curl localhost:8080/
```

Erro comum: `COPY site/ /usr/share/nginx/html/site/` (o nginx mostra a página padrão dele).

## Desafio 13 — Containers conversando

```bash
docker build -t receitas-api:1.6 .
docker network create cozinha
docker run -d --name receitas --network cozinha receitas-api:1.6
docker run --rm --network cozinha -v "$PWD:/app" python:3.12-slim python /app/cliente.py
```

A missão extra é reconhecida quando o `receitas` **não** publica porta nenhuma.

## Desafio 14 — Docker Compose

Crie e salve o arquivo `compose.yaml`, mantendo os espaços no início de cada linha:

```yaml
services:
  api:
    build: ./api

  web:
    build: ./web
    ports:
      - "8090:80"
    depends_on:
      - api
```

```bash
docker compose up -d --build
docker compose ps
curl localhost:8090/api/receitas
```

## Desafio 15 — Faxina

```bash
docker system df
docker stop $(docker ps -q)
docker container prune
docker image prune
```

Missão extra:

```bash
cd ~/labs/14-docker-compose && docker compose down && cd -
docker volume rm notas
docker network rm cozinha
docker image rm -f $(docker images -q 'receitas*' | sort -u) bloco:1.0
```
