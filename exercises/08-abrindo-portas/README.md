# Desafio 8 — Abrindo portas

⏱ 5 minutos · Módulo 3: Portas e configuração

## Objetivo

Acessar, do navegador, uma API que roda **dentro** de um container: publicar a porta com `-p` e documentá-la com `EXPOSE`.

## Onde

```bash
cd ~/labs/08-abrindo-portas
```

## Estado inicial

A API do desafio anterior (`app.py`, `requirements.txt`, `.dockerignore`) e um `Dockerfile` pronto, na ordem certa, mas sem `EXPOSE`.

## Portas: dentro e fora

O container tem a sua própria rede. O uvicorn escuta na porta 8000 **de lá**; ninguém de fora enxerga. `-p 8001:8000` liga a porta 8001 do Codespace à 8000 do container:

```
navegador ──▶ Codespace:8001 ──▶ container:8000 (uvicorn)
                  ▲ fora              ▲ dentro
```

A ordem é sempre `-p <fora>:<dentro>`. `EXPOSE 8000` no Dockerfile **não** abre porta nenhuma: só documenta qual porta o programa usa, para quem for rodar a imagem.

## Tarefa

1. Acrescente ao `Dockerfile`, antes do `CMD`:

   ```dockerfile
   EXPOSE 8000
   ```

   e construa:

   ```bash
   docker build -t receitas-api:1.3 .
   ```

2. Rode em segundo plano, publicando a porta:

   ```bash
   docker run -d --name api -p 8001:8000 receitas-api:1.3
   ```

3. Do terminal do Codespace:

   ```bash
   curl localhost:8001/receitas
   docker port api
   ```

4. Do navegador: na aba **PORTS** (ao lado de TERMINAL, na parte de baixo do VS Code), a porta 8001 aparece. Passe o mouse sobre ela e clique no ícone de globo (*Open in Browser*). O Codespace cria um endereço público temporário que leva até a porta 8001. Acrescente `/docs` ao endereço: o FastAPI gera essa página de documentação sozinho, e dá para testar as rotas por ela.

5. Cada requisição aparece nos logs do uvicorn:

   ```bash
   docker logs api
   ```

## Verificação

```bash
check.sh 08
```

## Dicas

- *port is already allocated*: outra coisa já usa a porta 8001 no Codespace. Escolha outra porta de fora (`-p 8011:8000`); a de dentro não muda.
- O `app.py` escuta em `0.0.0.0`, não em `127.0.0.1`. Dentro do container, `127.0.0.1` é só o próprio container; um servidor preso nele nunca recebe conexões de fora, mesmo com `-p`.

## Missão extra

Suba uma segunda cópia da mesma imagem em outra porta e veja as duas rodando lado a lado; depois remova a segunda:

```bash
docker run -d --name api2 -p 8005:8000 receitas-api:1.3
curl localhost:8005/receitas
docker rm -f api2
```
