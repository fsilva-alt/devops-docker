---
duration: 5
---

# Configuração por ambiente

{.lead}
Mudar o nome da cozinha exibido pela API **sem reconstruir a imagem**. Vamos usar uma **variável de ambiente**: uma configuração com nome e valor que o programa lê ao iniciar.

`ENV COZINHA="…"` `docker run -e COZINHA="…"` `--env-file cozinha.env` `docker exec <nome> env`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/09-configuracao-por-ambiente
```

O programa já lê a variável `COZINHA` e usa seu valor na mensagem da rota `/`. O Dockerfile ainda não define esse valor. O arquivo `cozinha.env` será usado na missão extra.
:::
:::card Para este desafio
`⏱ tempo`
: 5 min

`módulo`
: Módulo 3 · Portas e configuração

`verificação`
: `check.sh 09`
:::
::::

<p class="eyebrow">Conceito · variável COZINHA</p>

## Qual valor o programa usa?

<div class="flow"><div class="node dim"><b>Valor de reserva no código</b><small>"Cozinha sem nome" · usado se a variável não estiver definida</small></div><div class="arr"><span class="a">→</span>substituído por</div><div class="node"><b>Padrão da imagem</b><small>ENV COZINHA="Cozinha do Curso"</small></div><div class="arr"><span class="a">→</span>substituído por</div><div class="node hi"><b>Valor deste container</b><small>-e COZINHA="Cozinha da Ana" · ou um arquivo com --env-file</small></div></div>

:::card Como o programa lê a configuração
Neste trecho, já pronto em `app.py`, o programa procura a variável `COZINHA`. Se ela não existir, usa `Cozinha sem nome`.

```python
import os
COZINHA = os.environ.get("COZINHA", "Cozinha sem nome")
```

Definir outro valor ao criar o container permite mudar a configuração usando a mesma imagem.
:::

:::warning Segredos não vão em ENV no Dockerfile.
Ficam gravados na imagem, como o `.env` do desafio 7. Senhas entram por `-e` ou `--env-file`, na hora de rodar.
:::

:::note
**docker exec** executa um comando em um container que já está rodando. `docker exec cozinha env` lista suas variáveis de ambiente, incluindo o valor de `COZINHA`.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `ENV CHAVE="valor"` | padrão gravado na imagem |
| `docker run -e CHAVE="valor" …` | define (ou sobrescreve) só neste container; repita para várias |
| `docker run --env-file arquivo …` | várias de uma vez, uma CHAVE=valor por linha |
| `docker exec <nome> env` | o ambiente que o processo está vendo |
| `docker inspect <nome>` | em "Config" → "Env", tudo o que o container recebeu |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Como mudar a configuração de um container](https://docs.docker.com/get-started/docker-concepts/running-containers/overriding-container-defaults/)<small>-e, -p, --name e comando · em inglês</small>
- [Dockerfile · ENV](https://docs.docker.com/reference/dockerfile/#env)
- [Comando · docker run](https://docs.docker.com/reference/cli/docker/container/run/)<small>-d, -it, --rm, --name, -p, -e, -v, --network</small>
- [Comando · docker exec](https://docs.docker.com/reference/cli/docker/container/exec/)
:::

<p class="eyebrow">Tarefa · 5 min</p>

## O desafio

:::steps
1. No Dockerfile, acrescente `ENV COZINHA="Cozinha do Curso"` antes de `EXPOSE` e salve. Construa e consulte o valor padrão:

   ```console
   $ docker build -t receitas-api:1.4 .
   $ docker run --rm receitas-api:1.4 env | grep COZINHA
   ```

2. Crie o container com outro valor, usando `-e`. A resposta da API deve incluir `Cozinha da Ana`:

   ```console
   $ docker run -d --name cozinha -p 8002:8000 -e COZINHA="Cozinha da Ana" receitas-api:1.4
   $ curl localhost:8002/
   ```

3. Confira o valor configurado nesse container:

   ```console
   $ docker exec cozinha env | grep COZINHA
   ```
:::

:::card Verificação
```console
$ check.sh 09
```

Aprova quando a imagem tem um padrão e o `cozinha` roda com um valor **diferente**, respondendo em `localhost:8002`.
:::

:::note O que faz o símbolo \|?
Ele passa a saída de um comando para o seguinte. Aqui, `env` lista as variáveis, e `grep COZINHA` seleciona as linhas que contêm esse nome.
:::

:::card Missão extra · usar um arquivo
```console
$ cat cozinha.env
$ docker rm -f cozinha
$ docker run -d --name cozinha -p 8002:8000 --env-file cozinha.env receitas-api:1.4
$ curl localhost:8002/
```

O arquivo usa uma linha `NOME=valor` por variável. A verificação reconhece a missão extra quando o container usa o nome de cozinha desse arquivo.
:::
