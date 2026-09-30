# Exercício 16 — Desenvolvimento com Compose

⏱ 6 minutos · Docker Compose · **Opcional, para depois da aula**

Faça depois do exercício 14 e antes da faxina. Esta pasta tem os próprios arquivos, então o projeto do 14 fica como está.

## Objetivo

O fluxo do exercício 10 volta, agora descrito em YAML. Você configura um **bind mount no Compose** e edita a API sem reconstruir a imagem.

## Onde

```bash
cd ~/labs/16-compose-desenvolvimento
```

## Estado inicial

`app.py`, `requirements.txt`, `.dockerignore` e `Dockerfile` prontos. O programa usa `reload=True` para recarregar quando você salva o código. Falta criar `compose.yaml`.

## Tarefa

1. Execute `code compose.yaml`, copie o conteúdo abaixo e salve:

   ```yaml
   services:
     api:
       build: .
       image: receitas-api:dev
       ports:
         - "8100:8000"
       volumes:
         - .:/app
   ```

   `image` dá um nome à imagem construída. Em `volumes`, `.` indica a pasta do arquivo Compose, compartilhada em `/app` dentro do container. É um bind mount, porque a origem é um caminho.

2. Valide e inicie o serviço. Aguarde a mensagem de inicialização da API nos logs:

   ```bash
   docker compose config
   docker compose up -d --build
   docker compose logs api
   curl localhost:8100/receitas
   ```

3. Abra `app.py`, acrescente esta linha antes do `]` que fecha a lista `RECEITAS`, alinhada às demais, e salve:

   ```python
   {"nome": "Pudim", "rende": "8 porções"},
   ```

4. Consulte novamente. O Pudim deve aparecer sem que você execute outro build:

   ```bash
   docker compose logs api
   curl localhost:8100/receitas
   docker compose exec api cat /app/app.py
   docker run --rm receitas-api:dev cat /app/app.py
   ```

   O arquivo no serviço `api` tem o Pudim; o da imagem, não. `docker compose exec` usa o nome do serviço para executar um comando no container em execução.

## Verificação

```bash
check.sh 16
```

Confere a pasta compartilhada, a porta 8100, o Pudim na API e sua ausência na imagem.

## Missão extra

Adicione ao serviço `api`, no mesmo alinhamento de `build`:

```yaml
    environment:
      COZINHA: "Cozinha de desenvolvimento"
```

Execute `docker compose up -d` e consulte `curl localhost:8100/`. O Compose recria o container para mudar a configuração; editar o código pelo bind mount não exige essa recriação.

Ao terminar a verificação, use `docker compose down` para remover o serviço e a rede; os arquivos da pasta não são apagados.
