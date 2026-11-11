---
duration: 5
---

# Configuração por ambiente

{.lead}
Mudar o nome da cozinha que a API mostra **sem reconstruir a imagem**. Para isso, você usa uma **variável de ambiente**, uma configuração com nome e valor que o programa lê ao iniciar.

`ENV COZINHA="…"` `docker run -e COZINHA="…"` `--env-file cozinha.env` `docker exec <nome> env`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/09-configuracao-por-ambiente
```

O programa já lê a variável `COZINHA` e mostra o valor dela na rota `/`. O Dockerfile ainda não define essa variável. O arquivo `cozinha.env` fica para a missão extra.
:::
:::card Para este exercício
`⏱ tempo`
: 5 min

`parte`
: Portas e configuração

`verificação`
: `check.sh 09`
:::
::::

<p class="eyebrow">Conceito · variável COZINHA</p>

## Qual valor o programa usa?

<div class="flow"><div class="node dim"><b>Valor de reserva no código</b><small>"Cozinha sem nome" · usado se a variável não estiver definida</small></div><div class="arr"><span class="a">→</span>substituído por</div><div class="node"><b>Padrão da imagem</b><small>ENV COZINHA="Cozinha do Curso"</small></div><div class="arr"><span class="a">→</span>substituído por</div><div class="node hi"><b>Valor deste container</b><small>-e COZINHA="Cozinha da Ana" · ou um arquivo com --env-file</small></div></div>

:::card Como o programa lê a configuração
Este trecho já está pronto em `app.py`. O programa procura a variável `COZINHA` e, se ela não existir, usa `Cozinha sem nome`.

```python
import os
COZINHA = os.environ.get("COZINHA", "Cozinha sem nome")
```

Como o valor pode ser passado ao criar o container, a mesma imagem serve para configurações diferentes.
:::

:::warning Segredos não vão em ENV no Dockerfile.
Eles ficariam gravados na imagem, como o `.env` do exercício 7. Senhas entram por `-e` ou `--env-file`, na hora de rodar o container.
:::

:::note
**docker exec** executa um comando em um container que já está rodando. `docker exec cozinha env` lista as variáveis de ambiente dele, entre elas a `COZINHA`.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `ENV CHAVE="valor"` | valor padrão gravado na imagem |
| `docker run -e CHAVE="valor" …` | define o valor só neste container, no lugar do padrão; repita o -e para outras variáveis |
| `docker run --env-file arquivo …` | lê várias variáveis de um arquivo, uma CHAVE=valor por linha |
| `docker exec <nome> env` | mostra as variáveis que o programa recebeu |
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

## O exercício

:::steps
1. No Dockerfile, acrescente `ENV COZINHA="Cozinha do Curso"` antes de `EXPOSE` e salve. Construa a imagem e veja o valor padrão:

   ```console
   $ docker build -t receitas-api:1.4 .
   $ docker run --rm receitas-api:1.4 env | grep COZINHA
   ```

2. Crie o container com outro valor, usando `-e`. A resposta da API deve incluir `Cozinha da Ana`:

   ```console
   $ docker run -d --name cozinha -p 8002:8000 -e COZINHA="Cozinha da Ana" receitas-api:1.4
   $ curl localhost:8002/
   ```

3. Confira o valor que o container recebeu:

   ```console
   $ docker exec cozinha env | grep COZINHA
   ```
:::

:::card Verificação
```console
$ check.sh 09
```

Aprova quando a imagem tem um valor padrão e o container `cozinha` roda com um valor **diferente**, respondendo em `localhost:8002`.
:::

:::note O que faz o símbolo \|?
Ele passa a saída de um comando para o seguinte. Aqui, `env` lista as variáveis, e `grep COZINHA` mostra só as linhas que contêm esse nome.
:::

:::card Missão extra · usar um arquivo
```console
$ cat cozinha.env
$ docker rm -f cozinha
$ docker run -d --name cozinha -p 8002:8000 --env-file cozinha.env receitas-api:1.4
$ curl localhost:8002/
```

O arquivo tem uma linha `NOME=valor` para cada variável. A verificação reconhece a missão extra quando o container usa o nome de cozinha desse arquivo.
:::
