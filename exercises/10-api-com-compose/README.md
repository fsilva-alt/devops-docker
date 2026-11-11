# Exercício 10 — A API com Compose

⏱ 6 minutos · Portas e configuração

## Objetivo

Nos exercícios 8 e 9, você iniciou a API com um `docker run` comprido, com nome, porta, variável e imagem. O **Docker Compose** guarda essas opções em um arquivo, o `compose.yaml`, e inicia o container com um comando curto. Cada parte da aplicação descrita nesse arquivo é chamada de **serviço**. Aqui há um só, a `api`. No exercício 17, o site entra como o segundo.

## Onde

```bash
cd ~/labs/10-api-com-compose
```

## Estado inicial

A mesma API do exercício 9: `app.py`, `requirements.txt`, `.dockerignore` e um `Dockerfile` que já tem `ENV COZINHA="Cozinha do Curso"` e `EXPOSE 8000`. Há também o `cozinha.env`, para a missão extra. Só falta o `compose.yaml`.

## Do docker run para o compose.yaml

| No `docker run` | No `compose.yaml` |
|---|---|
| `docker build -t ... .` | `build: .` (a pasta do `Dockerfile`) |
| `-p 8010:8000` | `ports:` → `- "8010:8000"` |
| `-e COZINHA="Cozinha do Compose"` | `environment:` → `COZINHA: "Cozinha do Compose"` |
| `--name ...` | o nome do serviço, `api` |

## Tarefa

1. Execute `code compose.yaml`, copie o conteúdo abaixo e salve. **YAML** é um formato de texto usado para configurações. Os espaços no início das linhas, chamados de **indentação**, indicam o que pertence a cada item. Mantenha os dois espaços por nível do exemplo e não use a tecla Tab:

   ```yaml
   services:
     api:
       build: .
       ports:
         - "8010:8000"
       environment:
         COZINHA: "Cozinha do Compose"
   ```

2. Confira o arquivo e inicie o serviço. O `config` mostra o arquivo como o Compose entendeu, ou a linha com erro. O `up -d --build` constrói a imagem e inicia o container em segundo plano:

   ```bash
   docker compose config
   docker compose up -d --build
   docker compose ps
   ```

   Em `docker compose ps`, o container aparece como `10-api-com-compose-api-1`. O Compose usa o nome da pasta como prefixo.

3. Teste a API e veja os logs. A resposta deve incluir `Cozinha do Compose`. Se der erro logo no início, espere alguns segundos e tente de novo:

   ```bash
   curl localhost:8010/
   docker compose logs api
   ```

4. Remova tudo e inicie de novo. O `down` para e remove o container e a rede que o Compose criou. A imagem continua no Codespace, então o `up -d` seguinte não precisa construí-la outra vez:

   ```bash
   docker compose down
   docker compose ps
   docker compose up -d
   ```

## Verificação

```bash
check.sh 10
```

Aprova quando o serviço `api` está rodando, publica a porta 8010 e usa um nome de cozinha definido no `compose.yaml`, diferente do padrão da imagem.

## Dicas

- Os comandos do Compose leem o `compose.yaml` da pasta em que você está. Rode todos em `~/labs/10-api-com-compose`.
- Se o YAML tiver erro, `docker compose config` mostra a linha do problema. Confira os dois espaços por nível e o espaço depois de `-` e de `:`.
- Depois de mudar o `compose.yaml`, salve e rode `docker compose up -d` de novo. O Compose recria só o que mudou.

## Missão extra

Troque `environment` por `env_file`, que lê as variáveis de um arquivo, como o `--env-file` do exercício 9. O arquivo inteiro fica assim:

```yaml
services:
  api:
    build: .
    ports:
      - "8010:8000"
    env_file:
      - cozinha.env
```

Salve, rode `docker compose up -d` e teste com `curl localhost:8010/`. O nome da cozinha passa a ser `Cozinha da Vovó`, o valor que está em `cozinha.env`. A verificação marca a missão extra como concluída quando o serviço usa esse nome.
