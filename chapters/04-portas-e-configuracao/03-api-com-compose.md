---
duration: 6
---

# A API com Compose

{.lead}
Guardar as opções do `docker run` em um arquivo, o `compose.yaml`, e iniciar a API com **um comando curto**. A partir desse arquivo, o Docker Compose constrói a imagem, publica a porta e passa a variável `COZINHA`.

`compose.yaml` `docker compose up -d --build` `docker compose ps` `docker compose logs` `docker compose down`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/10-api-com-compose
```

A mesma API do exercício 9, com um Dockerfile que já tem `ENV COZINHA` e `EXPOSE 8000`. O arquivo `cozinha.env` fica para a missão extra. Só falta o `compose.yaml`.
:::
:::card Para este exercício
`⏱ tempo`
: 6 min

`parte`
: Portas e configuração

`verificação`
: `check.sh 10`
:::
::::

<p class="eyebrow">Conceito</p>

## As opções do docker run num arquivo

<div class="flow"><div class="node dim"><b>docker run</b><small>-d -p 8010:8000 -e COZINHA="…" e o nome da imagem, digitados a cada vez</small></div><div class="arr"><span class="a">→</span>escritas uma vez</div><div class="node"><b>compose.yaml</b><small>um serviço, api, com build, ports e environment</small></div><div class="arr"><span class="a">→</span>docker compose up -d</div><div class="node hi"><b>container da api</b><small>10-api-com-compose-api-1 · porta 8010</small></div></div>

```yaml
services:
  api:
    build: .
    ports:
      - "8010:8000"
    environment:
      COZINHA: "Cozinha do Compose"
```

**YAML** é um formato de texto para configurações. Os espaços no início de cada linha mostram o que pertence a quê. Use dois espaços por nível, como no exemplo, e não use Tab. `docker compose config` confere se o arquivo está válido.

| Configuração | O que faz |
| --- | --- |
| `services:` | lista os serviços, que são as partes da aplicação; aqui há um só, `api` |
| `build: .` | constrói a imagem com o Dockerfile da pasta atual, como o `docker build` |
| `ports:` | publica a porta, como o `-p` |
| `environment:` | define variáveis de ambiente, como o `-e` |

:::note O Compose escolhe o nome do container.
O container se chama `10-api-com-compose-api-1`, formado pelo nome da pasta, pelo nome do serviço e por um número. Nos comandos do Compose, você usa só o nome do serviço, como em `docker compose logs api`.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker compose up -d --build` | constrói as imagens e inicia os serviços em segundo plano |
| `docker compose ps` | os containers do projeto e o estado de cada um |
| `docker compose logs [-f] [serviço]` | logs de todos ou de um |
| `docker compose exec <serviço> <cmd>` | como o docker exec, pelo nome do serviço |
| `docker compose down` | para e remove containers e rede; -v remove volumes também |
| `docker compose config` | valida e mostra o arquivo interpretado |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Guia do Docker Compose](https://docs.docker.com/compose/)
- [Referência do arquivo Compose](https://docs.docker.com/reference/compose-file/)<small>services, build, ports, environment, volumes · em inglês</small>
- [Comando · docker compose up](https://docs.docker.com/reference/cli/docker/compose/up/)<small>-d, --build</small>
- [Comando · docker compose ps](https://docs.docker.com/reference/cli/docker/compose/ps/)
- [Comando · docker compose logs](https://docs.docker.com/reference/cli/docker/compose/logs/)
- [Comando · docker compose down](https://docs.docker.com/reference/cli/docker/compose/down/)<small>-v, --rmi</small>
:::

<p class="eyebrow">Tarefa · 6 min</p>

## O exercício

:::steps
1. Rode `code compose.yaml`, copie o conteúdo do slide anterior e salve. Confira os espaços no início de cada linha.

2. Confira o arquivo e inicie o serviço. O `config` mostra o arquivo como o Compose entendeu, ou a linha com erro. O `--build` constrói a imagem antes de iniciar, e o `-d` deixa o terminal livre:

   ```console
   $ docker compose config
   $ docker compose up -d --build
   $ docker compose ps
   ```

3. Teste a API e veja os logs. A resposta deve incluir `Cozinha do Compose`. Se der erro logo no início, espere alguns segundos e tente de novo:

   ```console
   $ curl localhost:8010/
   $ docker compose logs api
   ```

4. Remova o container com `down` e inicie de novo com `up`. A imagem continua no Codespace, então o segundo `up` não precisa do `--build`:

   ```console
   $ docker compose down
   $ docker compose up -d
   ```
:::

:::card Verificação
```console
$ check.sh 10
```

Aprova quando o serviço `api` está rodando na porta 8010 com um nome de cozinha definido no `compose.yaml`, diferente do padrão da imagem.
:::

:::note Rode os comandos na pasta do compose.yaml.
O Compose lê o arquivo da pasta em que você está. Depois de mudar o arquivo, salve e rode `docker compose up -d` de novo. Ele recria só o que mudou.
:::

:::card Missão extra · usar um arquivo
Troque `environment` por `env_file`, que lê as variáveis de `cozinha.env`, como o `--env-file` do exercício 9:

```yaml
services:
  api:
    build: .
    ports:
      - "8010:8000"
    env_file:
      - cozinha.env
```

Salve, rode `docker compose up -d` e teste com `curl localhost:8010/`. O nome da cozinha passa a ser `Cozinha da Vovó`.
:::
