---
duration: 5
---

# Abrindo portas

{.lead}
Acessar, do navegador, uma API que roda **dentro** de um container: publicar a porta com `-p` e documentá-la com `EXPOSE`.

`EXPOSE 8000` `docker run -d -p 8001:8000` `curl localhost:8001/receitas` `docker port` `aba PORTS` `/docs`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/08-abrindo-portas
```

A API (`app.py`, `requirements.txt`, `.dockerignore`) e um `Dockerfile` pronto, na ordem certa, mas sem `EXPOSE`.
:::
:::card Para este desafio
`⏱ tempo`
: 5 min

`módulo`
: Módulo 3 · Portas e configuração

`verificação`
: `check.sh 08`
:::
::::

<p class="eyebrow">Conceito · -p fora:dentro</p>

## Como acessar a porta do container?

<div class="flow"><div class="node"><b>navegador / curl</b><small>curl: localhost:8001 · navegador: endereço da aba PORTS</small></div><div class="arr"><span class="a">→</span><strong>-p 8001:8000</strong></div><div class="node hi"><b>Codespace :8001</b><small>porta da máquina que executa o Docker</small></div><div class="arr"><span class="a">→</span>encaminha</div><div class="node"><b>container :8000</b><small>uvicorn recebe os pedidos nesta porta</small></div></div>

::::columns
:::card Publicar uma porta com -p
Uma **porta** é um número que direciona conexões a um programa. `-p 8001:8000` encaminha os pedidos recebidos na porta 8001 do Codespace à porta 8000 do container.

A ordem é **`fora:dentro`**: primeiro o Codespace, depois o container.
:::
:::card Registrar a porta com EXPOSE
`EXPOSE 8000` informa, no Dockerfile, qual porta o programa usa. Essa instrução sozinha não publica a porta no Codespace; fazemos isso com `-p` ao criar o container.
:::
:::card A configuração do servidor
`127.0.0.1` aceita conexões apenas do próprio ambiente em que o programa roda. No container, isso impediria o acesso de fora. O código fornecido usa `0.0.0.0` para aceitar essas conexões.
:::
::::

:::note Terminal e navegador usam endereços diferentes.
No terminal do Codespace, `localhost` aponta para o Codespace. No navegador do seu computador, use o endereço fornecido pela aba **PORTS**: passe o mouse sobre a porta e clique no globo, *Open in Browser*. O acesso depende da configuração de visibilidade da porta.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker run -p <fora>:<dentro> …` | publica a porta; pode repetir -p para várias |
| `EXPOSE 8000` | documenta a porta no Dockerfile (sem abrir) |
| `docker port <nome>` | mostra quais portas do Codespace estão ligadas às do container |
| `curl localhost:<fora>/…` | acessa a aplicação pelo terminal do Codespace |
| `docker ps` | a coluna PORTS mostra 0.0.0.0:8001-\>8000/tcp |
| `/docs` | página gerada pelo FastAPI para consultar e testar as rotas deste projeto |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Como publicar portas](https://docs.docker.com/get-started/docker-concepts/running-containers/publishing-ports/)<small>em inglês</small>
- [Dockerfile · EXPOSE](https://docs.docker.com/reference/dockerfile/#expose)
- [Comando · docker port](https://docs.docker.com/reference/cli/docker/container/port/)
- [GitHub Docs · Encaminhar portas no Codespace](https://docs.github.com/pt/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace)<small>a aba PORTS · pt-br</small>
- [Comando · docker run](https://docs.docker.com/reference/cli/docker/container/run/)<small>-d, -it, --rm, --name, -p, -e, -v, --network</small>
:::

<p class="eyebrow">Tarefa · 5 min</p>

## O desafio

:::steps
1. Abra o `Dockerfile`, acrescente `EXPOSE 8000` antes de `CMD` e salve. No terminal, construa a imagem:

   ```console
   $ docker build -t receitas-api:1.3 .
   ```

2. Rode em segundo plano, publicando a porta:

   ```console
   $ docker run -d --name api -p 8001:8000 receitas-api:1.3
   ```

3. Teste com `curl`, que acessa o endereço e mostra a resposta no terminal. Depois, consulte a ligação entre as portas:

   ```console
   $ curl localhost:8001/receitas
   $ docker port api
   ```

4. Na aba **PORTS**, abra a porta **8001** pelo ícone de globo. Acrescente `/docs` ao endereço. Nessa página, expanda **GET /receitas**, clique em **Try it out** e depois em **Execute** para testar a API.

5. Cada pedido à API, chamado de **requisição**, aparece nos logs:

   ```console
   $ docker logs api
   ```
:::

:::card Verificação
```console
$ check.sh 08
```

Confere o `EXPOSE`, o container `api` na 8001 e a resposta de `/receitas`.
:::

:::warning
**Se a conexão falhar logo no início:** espere alguns segundos e tente novamente. Já *port is already allocated* significa que a porta está ocupada. Consulte `docker ps` para identificar o container que a usa; a verificação deste desafio espera a porta 8001.
:::

:::card Missão extra
```console
$ docker run -d --name api2 -p 8005:8000 receitas-api:1.3
$ curl localhost:8005/receitas
$ docker rm -f api2
```

Duas cópias da mesma imagem, lado a lado, em portas diferentes.
:::
