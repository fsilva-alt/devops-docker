# Desafio 0 — Docker funciona?

⏱ 3 minutos · feito **antes da aula**, logo depois do instalador

## Objetivo

Confirmar que o seu Codespace consegue rodar containers. Se algo estiver errado aqui, é melhor descobrir com um dia de folga do que no meio da aula.

## Onde

No terminal do Codespace, em qualquer pasta. O Docker gerencia os containers e as imagens; estes comandos não dependem da pasta em que o terminal está.

## Como o Docker funciona

Um Codespace criado com o modelo **Blank** vem com o Docker instalado. Um **container** é um ambiente isolado para executar um programa. Ele é criado a partir de uma **imagem**, que reúne o programa e os arquivos necessários para executá-lo. Para isso, o Docker usa duas partes:

| Peça | O que é |
|---|---|
| `docker` | O **cliente**: o comando que você digita no terminal |
| `dockerd` | O **daemon**, um serviço que permanece em execução e recebe os pedidos do cliente para baixar imagens, criar e executar containers |

Se aparecer *Cannot connect to the Docker daemon* (não foi possível conectar ao serviço do Docker), o cliente está instalado, mas não conseguiu acessar o serviço. Em um Codespace recém-aberto, espere um minuto e tente de novo.

## Tarefa

1. Execute o comando abaixo no terminal e pressione Enter. Ele mostra as versões do cliente (**Client**) e do serviço (**Server**). Se as duas aparecerem, a comunicação está funcionando:

   ```bash
   docker version
   ```

2. Execute seu primeiro container. A imagem `hello-world` contém um pequeno programa de teste:

   ```bash
   docker run hello-world
   ```

   Procure a mensagem **Hello from Docker!**. O texto em inglês explica o processo: o cliente envia o pedido, o serviço obtém a imagem, cria um container e mostra a mensagem no terminal. Se a imagem já estiver disponível, não é preciso baixá-la novamente.

3. Confira se o Docker Compose também está disponível. Essa ferramenta será usada no desafio 14 para iniciar mais de um serviço com um comando:

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

Execute `docker info` para consultar um resumo do serviço Docker. Procure a linha `Containers:`, que mostra o total de containers, incluindo os parados. O container de teste `hello-world` deve estar nessa contagem.
