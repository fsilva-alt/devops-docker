# Desafio 0 — Docker funciona?

⏱ 3 minutos · feito **antes da aula**, logo depois do instalador

## Objetivo

Confirmar que o seu Codespace consegue rodar containers. Se algo estiver errado aqui, é melhor descobrir com um dia de folga do que no meio da aula.

## Onde

Em qualquer pasta. Containers e imagens não moram em pasta nenhuma: eles ficam com o Docker.

## O Docker que já está aí

Um Codespace criado do template **Blank** vem com o Docker instalado. São duas peças:

| Peça | O que é |
|---|---|
| `docker` | O **cliente**: o comando que você digita no terminal |
| `dockerd` | O **daemon** (serviço): quem de fato baixa imagens, cria e roda containers. O cliente só manda pedidos para ele |

Quando `docker` reclama de *Cannot connect to the Docker daemon*, o cliente está lá, mas o serviço ainda não subiu. Num Codespace recém-aberto, espere um minuto e tente de novo.

## Tarefa

1. Veja as versões do cliente e do servidor. Se as duas aparecem, eles estão conversando:

   ```bash
   docker version
   ```

2. Rode o seu primeiro container. A imagem `hello-world` é minúscula e só existe para isso:

   ```bash
   docker run hello-world
   ```

   Leia a mensagem: ela conta, em quatro passos, o que acabou de acontecer (o cliente pediu, o daemon baixou a imagem, criou um container a partir dela e mostrou a saída para você).

3. Confira que o Compose, usado no desafio 14, também está disponível:

   ```bash
   docker compose version
   ```

## Verificação

```bash
check.sh 00
```

A verificação também confere que o instalador conseguiu baixar as quatro imagens-base da aula (`hello-world`, `alpine`, `python:3.12-slim`, `nginx:alpine`). Se faltar alguma, rode `setup.sh`.

## Dica

Depois de conferir, **pare o Codespace** em [github.com/codespaces](https://github.com/codespaces) (⋯ → *Stop codespace*), para não gastar sua franquia gratuita. No dia da aula, é só abrir de novo: imagens e laboratórios continuam lá.

## Missão extra

`docker info` mostra um resumo do daemon: quantos containers e imagens existem, qual o *storage driver*, onde ficam os dados (`Docker Root Dir`). Ache a linha `Containers:` e confira que o `hello-world` está contado.
