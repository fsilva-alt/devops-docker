# Desafio 9 — Configuração por ambiente

⏱ 5 minutos · Módulo 3: Portas e configuração

## Objetivo

Mudar o nome da cozinha exibido pela API **sem reconstruir a imagem**. Vamos usar uma **variável de ambiente**, uma configuração com nome e valor que o programa lê ao iniciar. Neste exercício, o nome é `COZINHA`, e o valor pode ser `Cozinha da Ana`.

## Onde

```bash
cd ~/labs/09-configuracao-por-ambiente
```

## Estado inicial

O `app.py` agora lê uma variável de ambiente:

```python
COZINHA = os.environ.get("COZINHA", "Cozinha sem nome")
```

Essa linha procura o valor de `COZINHA`. Se ele não estiver definido, usa `Cozinha sem nome`. A rota `/` inclui o nome escolhido na mensagem do livro de receitas. O `Dockerfile` já está pronto, mas ainda não define essa variável. Há também um arquivo `cozinha.env` para a missão extra.

## Qual valor o programa usa?

| Onde definir | Quando é usado | Substitui |
|---|---|---|
| Código: `os.environ.get("COZINHA", "Cozinha sem nome")` | Quando a variável não está definida | — |
| `ENV COZINHA="..."` no Dockerfile | Como valor padrão da imagem | O valor de reserva do código |
| `-e COZINHA="..."` ou `--env-file` no `docker run` | No container que você está criando | O padrão da imagem |

Isso permite usar a mesma imagem com configurações diferentes. Por exemplo, você pode mudar o nome da cozinha ou o endereço de outro serviço ao criar um container.

## Tarefa

1. Abra o `Dockerfile`, acrescente a linha abaixo antes de `EXPOSE` e salve. Ela define o valor padrão da imagem:

   ```dockerfile
   ENV COZINHA="Cozinha do Curso"
   ```

   ```bash
   docker build -t receitas-api:1.4 .
   docker run --rm receitas-api:1.4 env | grep COZINHA
   ```

   `env` lista as variáveis de ambiente. O símbolo `|` passa essa lista ao comando `grep COZINHA`, que mostra apenas as linhas que contêm `COZINHA`.

2. Crie o container com outro valor, usando `-e`. Depois, consulte a API; a resposta deve incluir `Cozinha da Ana`:

   ```bash
   docker run -d --name cozinha -p 8002:8000 -e COZINHA="Cozinha da Ana" receitas-api:1.4
   curl localhost:8002/
   ```

3. Confira o valor recebido pelo container. `docker exec` executa um comando dentro de um container que já está em execução:

   ```bash
   docker exec cozinha env | grep COZINHA
   ```

## Verificação

```bash
check.sh 09
```

Aprova quando a imagem tem um padrão e o container `cozinha` roda com um valor **diferente** do padrão, respondendo em `localhost:8002`.

## Dica

Não coloque segredos em `ENV` no Dockerfile: eles ficam gravados na imagem (lembra do `.env` no desafio 7?). Senhas entram por `-e` ou `--env-file`, na hora de rodar.

## Missão extra

Você também pode reunir as variáveis em um arquivo, com uma linha no formato `NOME=valor` para cada uma. Leia `cozinha.env` com `cat cozinha.env`. Depois, recrie o container usando esse arquivo:

```bash
docker rm -f cozinha
docker run -d --name cozinha -p 8002:8000 --env-file cozinha.env receitas-api:1.4
curl localhost:8002/
```

A verificação marca a missão extra como concluída quando o container usa o nome de cozinha definido no arquivo.
