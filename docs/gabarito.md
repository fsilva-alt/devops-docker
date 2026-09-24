# Gabarito

Sequência de comandos que resolve cada desafio. Serve para o professor, para os monitores e para quem quiser conferir depois da aula. A versão executável, usada pelos testes, está em `tests/solucoes.sh`.

Os desafios 4 a 14 começam com `cd ~/labs/NN-nome`. Os outros rodam em qualquer pasta.

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

```bash
docker run -it --rm python:3.12-slim          # >>> exit()
docker run -it --name explorador python:3.12-slim bash
# dentro: cat /etc/os-release; ls /; echo "eu estive aqui" > /marca.txt; exit
docker run --rm python:3.12-slim cat /marca.txt   # No such file: outro container
```

Se sobrou um container do REPL (faltou `--rm`), a verificação reclama: `docker rm <id>`.

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

1. `docker build -t receitas-api:1.1 .`
2. Acrescentar uma receita em `app.py`; build de novo (o pip roda outra vez).
3. Reordenar:

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

4. Build; editar `app.py`; build (pip `CACHED`). `docker history receitas-api:1.1`.

A verificação exige o `app.py` diferente do original **e** igual ao que está dentro da imagem.

## Desafio 7 — O que não entra na imagem

```bash
printf '.venv\n__pycache__\n.env\nnotas-pessoais.md\nfotos\n' > .dockerignore
docker build -t receitas-api:1.2 .
docker run --rm receitas-api:1.2 ls -A /app
```

## Desafio 8 — Abrindo portas

Acrescentar `EXPOSE 8000` antes do `CMD`, depois:

```bash
docker build -t receitas-api:1.3 .
docker run -d --name api -p 8001:8000 receitas-api:1.3
curl localhost:8001/receitas
```

No navegador: aba PORTS → 8001 → globo → `/docs`.

## Desafio 9 — Configuração por ambiente

Acrescentar `ENV COZINHA="Cozinha do Curso"` antes do `EXPOSE`, depois:

```bash
docker build -t receitas-api:1.4 .
docker run -d --name cozinha -p 8002:8000 -e COZINHA="Cozinha da Ana" receitas-api:1.4
curl localhost:8002/
```

Missão extra: `docker rm -f cozinha && docker run -d --name cozinha -p 8002:8000 --env-file cozinha.env receitas-api:1.4`.

## Desafio 10 — Editando ao vivo

```bash
docker build -t receitas-api:1.5 .
docker run -d --name dev -p 8003:8000 -v "$PWD:/app" receitas-api:1.5
# editar app.py: {"nome": "Pudim", "rende": "8 porções"},
curl localhost:8003/receitas
```

## Desafio 11 — Dados que ficam

```bash
docker build -t bloco:1.0 .
docker run --rm bloco:1.0 "comprar cenouras"
docker run --rm bloco:1.0 "assar o bolo"      # só uma nota: a anterior morreu
docker volume create notas
docker run --rm -v notas:/dados bloco:1.0 "comprar cenouras"
docker run --rm -v notas:/dados bloco:1.0 "assar o bolo"
```

## Desafio 12 — Site estático

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

`compose.yaml`:

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
