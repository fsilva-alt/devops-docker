# Exercício 0 — Docker funciona?

⏱ 3 minutos · feito **antes da aula**, logo depois do instalador

## Objetivo

Antes da aula, execute seu primeiro container e confira se o ambiente está pronto para os exercícios. Fazendo isso com antecedência, você se acostuma com o terminal e ainda tem tempo de pedir ajuda se aparecer algum erro.

## Onde

No terminal do Codespace, em qualquer pasta. Quem cuida dos containers e das imagens é o Docker, então estes comandos não dependem da pasta em que o terminal está.

## Como o Docker funciona

Um Codespace criado com o modelo **Blank** já vem com o Docker instalado. Um **container** é um ambiente isolado onde um programa é executado. Ele é criado a partir de uma **imagem**, que reúne o programa e os arquivos de que ele precisa. O Docker tem duas partes:

| Peça | O que é |
|---|---|
| `docker` | O **cliente**: o comando que você digita no terminal |
| `dockerd` | O **daemon**, um serviço que permanece em execução e recebe os pedidos do cliente para baixar imagens, criar e executar containers |

Se aparecer *Cannot connect to the Docker daemon* (não foi possível conectar ao serviço do Docker), o cliente está instalado, mas não conseguiu acessar o serviço. Em um Codespace recém-aberto, espere um minuto e tente de novo.

## Tarefa

1. Digite o comando abaixo no terminal e pressione Enter. Ele mostra a versão do cliente (**Client**) e a do serviço (**Server**). Se as duas aparecerem, cliente e serviço estão se comunicando:

   ```bash
   docker version
   ```

2. Execute seu primeiro container. A imagem `hello-world` contém um pequeno programa de teste:

   ```bash
   docker run hello-world
   ```

   Procure a mensagem **Hello from Docker!**. O texto em inglês que vem em seguida descreve o que aconteceu. O cliente enviou o pedido, e o serviço obteve a imagem, criou um container e mostrou a mensagem no terminal. Se a imagem já estiver no Codespace, o Docker não a baixa de novo.

3. Confira se o Docker Compose também está instalado. Ele aparece no exercício 14 e serve para iniciar vários serviços com um único comando:

   ```bash
   docker compose version
   ```

## Verificação

```bash
check.sh 00
```

Além do Docker, a verificação confere se o instalador baixou as quatro imagens-base da aula (`hello-world`, `alpine`, `python:3.12-slim`, `nginx:alpine`). Se faltar alguma, rode `setup.sh`. Em seguida, ela cria dois containers em uma rede temporária, testa se um encontra o outro pelo nome e apaga o que criou para o teste. É essa comunicação pela rede que os exercícios 13 e 14 vão usar. Se algo falhar, siga a dica exibida e consulte o [guia do aluno](../../docs/guia-do-aluno.md).

## Dica

Depois de conferir, **pare o Codespace** em [github.com/codespaces](https://github.com/codespaces) (⋯ → *Stop codespace*), para não gastar sua franquia gratuita. No dia da aula, abra o mesmo Codespace de novo; as imagens e os laboratórios estarão guardados nele.

## Missão extra

Execute `docker info` para ver um resumo do serviço Docker. Procure a linha `Containers:`, que mostra o total de containers, incluindo os parados. O container do teste com `hello-world` entra nessa conta.
