---
duration: 5
---

# Abrindo portas

{.lead}
Abrir no navegador uma API que roda **dentro** de um container, publicando a porta com `-p` e documentando-a com `EXPOSE`.

`EXPOSE 8000` `docker run -d -p 8001:8000` `curl localhost:8001/receitas` `docker port` `aba PORTS` `/docs`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/08-abrindo-portas
```

A API (`app.py`, `requirements.txt`, `.dockerignore`) e um `Dockerfile` pronto, na ordem certa, mas sem `EXPOSE`.
:::
:::card Para este exercício
`⏱ tempo`
: 5 min

`parte`
: Portas e configuração

`verificação`
: `check.sh 08`
:::
::::

<p class="eyebrow">Conceito · -p fora:dentro</p>

## Como acessar a porta do container?

<div class="flow"><div class="node"><b>navegador / curl</b><small>curl: localhost:8001 · navegador: endereço da aba PORTS</small></div><div class="arr"><span class="a">→</span><strong>-p 8001:8000</strong></div><div class="node hi"><b>Codespace :8001</b><small>porta da máquina que executa o Docker</small></div><div class="arr"><span class="a">→</span>encaminha</div><div class="node"><b>container :8000</b><small>uvicorn recebe os pedidos nesta porta</small></div></div>

::::columns
:::card Publicar uma porta com -p
Uma **porta** é um número que leva as conexões até um programa. Com `-p 8001:8000`, os pedidos que chegam à porta 8001 do Codespace são repassados à porta 8000 do container.

A ordem é **`fora:dentro`**: primeiro o Codespace, depois o container.
:::
:::card Registrar a porta com EXPOSE
`EXPOSE 8000` registra, no Dockerfile, a porta que o programa usa. Sozinha, essa instrução não publica a porta no Codespace. Quem faz isso é o `-p`, na hora de criar o container.
:::
:::card A configuração do servidor
Um servidor que escuta em `127.0.0.1` só aceita pedidos vindos do próprio container, e publicar a porta não muda isso. Por isso, o código do curso usa `0.0.0.0`, que aceita também os pedidos de fora.
:::
::::

:::note Terminal e navegador usam endereços diferentes.
No terminal do Codespace, `localhost` é o próprio Codespace. No navegador do seu computador, `localhost` é o seu computador, então use o endereço da aba **PORTS**: passe o mouse sobre a porta e clique no globo, *Open in Browser*. O acesso a esse endereço depende da visibilidade configurada para a porta.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker run -p <fora>:<dentro> …` | publica a porta; repita o -p para publicar várias |
| `EXPOSE 8000` | documenta a porta no Dockerfile, sem publicar |
| `docker port <nome>` | mostra quais portas do Codespace estão ligadas às do container |
| `curl localhost:<fora>/…` | testa a API pelo terminal do Codespace |
| `docker ps` | a coluna PORTS mostra 0.0.0.0:8001-\>8000/tcp |
| `/docs` | página que o FastAPI gera para ver e testar as rotas da API |

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

## O exercício

:::steps
1. Abra o `Dockerfile`, acrescente `EXPOSE 8000` antes de `CMD` e salve. No terminal, construa a imagem:

   ```console
   $ docker build -t receitas-api:1.3 .
   ```

2. Rode o container em segundo plano, publicando a porta:

   ```console
   $ docker run -d --name api -p 8001:8000 receitas-api:1.3
   ```

3. Teste a API com `curl`, que acessa um endereço e mostra a resposta no terminal. O segundo comando mostra a ligação entre as portas:

   ```console
   $ curl localhost:8001/receitas
   $ docker port api
   ```

4. Na aba **PORTS**, abra a porta **8001** pelo ícone de globo e acrescente `/docs` ao final do endereço. Nessa página, expanda **GET /receitas**, clique em **Try it out** e depois em **Execute** para testar a API.

5. Cada pedido feito à API, chamado de **requisição**, aparece nos logs:

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
**Se a conexão for recusada logo no início:** espere alguns segundos e tente de novo. Já *port is already allocated* quer dizer que outro container está usando a porta 8001. Veja qual é com `docker ps` e remova-o, porque a verificação espera a API nessa porta.
:::

:::card Missão extra
```console
$ docker run -d --name api2 -p 8005:8000 receitas-api:1.3
$ curl localhost:8005/receitas
$ docker rm -f api2
```

Os dois containers usam a mesma imagem e rodam ao mesmo tempo, cada um em uma porta do Codespace. A última linha remove o segundo.
:::
