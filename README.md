# Curso de Docker no GitHub Codespaces

Uma aula ao vivo de 3 horas, pelo Zoom, com exercícios feitos no navegador. Você vai usar o GitHub Codespaces, que oferece um computador Linux pela internet, com editor de arquivos, terminal e Docker instalado. Cada pessoa terá seu próprio ambiente, chamado **Codespace**.

Não é preciso ter experiência com programação ou Docker. Os programas usados nos exercícios já vêm prontos; você vai aprender a executá-los em containers e fazer pequenas alterações seguindo os exemplos.

> **Aluno?** Siga a seção [Antes da aula](#antes-da-aula) agora e, no dia, a [Sequência da aula](#sequência-da-aula).
> **Professor ou monitor?** Veja o [guia do professor](docs/guia-do-professor.md).

## O que você vai aprender

- entender o que é um container: um ambiente isolado para executar um programa;
- criar containers a partir de imagens, que reúnem o programa e os arquivos necessários para executá-lo;
- iniciar, parar e remover containers, além de consultar suas mensagens de funcionamento, chamadas **logs**;
- escrever um `Dockerfile`, o arquivo com as instruções para construir uma imagem;
- acessar um programa pelo navegador e ajustar suas configurações;
- compartilhar pastas com um container e guardar dados mesmo depois de removê-lo;
- executar um site e uma API, que fornece dados para outros programas;
- usar o Docker Compose para iniciar o site e a API juntos;
- remover os recursos criados durante a aula e liberar espaço.

A ementa completa, com cronograma, está em [docs/ementa.md](docs/ementa.md).

## Antes da aula

Faça esta preparação **pelo menos um dia antes**. Assim, há tempo para resolver possíveis problemas de acesso.

1. Crie uma conta no [GitHub](https://github.com), se ainda não tiver uma, e entre nela.
2. Crie um Codespace em branco: acesse [github.com/codespaces](https://github.com/codespaces) e escolha o modelo **Blank** (em branco). A página [codespaces/new](https://github.com/codespaces/new) também dá acesso à criação de um ambiente. A primeira criação costuma levar de 1 a 3 minutos.
3. O editor **VS Code** abrirá no navegador. Nele, abra o menu **Terminal → New Terminal** (novo terminal). O terminal é a área onde você digita comandos para o computador executar. Cole a linha abaixo nessa área e pressione **Enter**:

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fsilva-alt/devops-docker/main/install.sh)"
   ```

   Esse comando baixa e executa o instalador do curso. Ele salva o material em `~/devops-docker`, baixa as imagens usadas na aula e prepara os arquivos dos exercícios em `~/labs`. Aguarde a mensagem **"Curso de Docker instalado com sucesso!"**. O símbolo `~` representa sua pasta pessoal no Codespace.

4. Abra outro terminal pelo menu **Terminal → New Terminal**. Execute os comandos abaixo, **um por vez**, pressionando Enter ao final de cada linha:

   ```bash
   docker run hello-world
   check.sh 00
   ```

   O primeiro comando executa um container de teste. O segundo verifica se o ambiente está pronto. Se aparecer **concluído**, você pode seguir. Se aparecer uma dica, siga a orientação e tente novamente. O [desafio 0](exercises/00-docker-funciona/README.md) explica cada etapa.

5. Pare o Codespace para não gastar sua franquia gratuita: em [github.com/codespaces](https://github.com/codespaces), **⋯ → Stop codespace**. No dia da aula, é só abrir de novo. Tudo continua lá.

## Como o ambiente funciona

### Primeiros passos no terminal e no editor

- **Executar um comando:** copie a linha para o terminal e pressione Enter. Espere o comando terminar antes de executar o próximo. Alguns programas continuam rodando; nesses casos, o exercício explica como sair.
- **Ler os exemplos:** linhas de comando vão no terminal. Blocos identificados como `Dockerfile`, Python ou YAML devem ser escritos no arquivo indicado pelo exercício. Nos slides, o `$` no início de uma linha marca um comando; não copie esse símbolo. Linhas que começam com `#` são comentários explicativos.
- **Entrar em uma pasta:** use `cd`, seguido do caminho, como em `cd ~/labs/04-meu-primeiro-dockerfile`. `pwd` mostra em qual pasta você está; `ls` lista o conteúdo dela; `cat nome-do-arquivo` mostra um arquivo no terminal.
- **Abrir ou criar um arquivo:** depois de entrar na pasta do exercício, digite `code Dockerfile`, por exemplo. O VS Code abre o arquivo para edição; se ele ainda não existir, você poderá criá-lo. Salve com **Ctrl+S** ou **Cmd+S** no Mac.
- **Usar os nomes dos exemplos:** mantenha os nomes de arquivos, imagens e containers pedidos nos enunciados. A verificação procura esses nomes.

Nos exemplos genéricos, `NN` representa o número do desafio: `check.sh NN` vira `check.sh 05` para o desafio 5. Da mesma forma, `<nome>` indica um valor a substituir; os sinais `<` e `>` não fazem parte do comando. Nas tabelas de referência, `[comando]` indica uma parte opcional, e `…` indica que o exemplo está abreviado. Para executar, use as linhas completas da seção **Tarefa**.

### Onde ficam os arquivos

| Onde | O quê |
|---|---|
| `~/devops-docker/` | Este repositório: enunciados, scripts e documentos |
| `~/devops-docker/exercises/NN-nome/README.md` | O enunciado de cada desafio |
| `~/labs/NN-nome/` | Os arquivos de partida dos desafios 4 a 14 (código, Dockerfiles, site) |

Os desafios 0 a 3 e 15 não precisam de uma pasta de exercício. Neles, você usa comandos que consultam ou alteram os recursos gerenciados pelo Docker, independentemente da pasta atual do terminal.

Comandos disponíveis no terminal:

| Comando | Faz |
|---|---|
| `check.sh NN` | Confere o resultado do desafio e mostra ✅ quando estiver concluído, ou dicas do que ajustar |
| `reset.sh NN` | Recomeça o desafio: apaga as alterações na pasta dele e remove os containers, imagens, volumes e redes previstos para esse exercício |
| `setup.sh` | Baixa imagens e gera os laboratórios que ainda não existem; o instalador já rodou isso |

Dentro da pasta de um laboratório, `check.sh` e `reset.sh` funcionam sem o número. Se usar `reset.sh`, entre novamente na pasta com o comando `cd` do enunciado antes de continuar. Para abrir um enunciado no editor, use, por exemplo: `code ~/devops-docker/exercises/08-abrindo-portas/README.md`.

## Sequência da aula

| # | Desafio | Tema |
|---|---|---|
| [0](exercises/00-docker-funciona/README.md) | Docker funciona? | `docker version`, `run hello-world` (antes da aula) |
| [1](exercises/01-ola-container/README.md) | Olá, container | `docker run`, `ps -a`, `images`; imagem × container |
| [2](exercises/02-dentro-do-container/README.md) | Dentro do container | `-it`, `--rm`, `--name`; cada container tem o seu sistema de arquivos |
| [3](exercises/03-ciclo-de-vida/README.md) | Ciclo de vida | `-d`, `logs`, `stop`, `start`, `rm` |
| [4](exercises/04-meu-primeiro-dockerfile/README.md) | Meu primeiro Dockerfile | `FROM`, `COPY`, `CMD`, `build -t`, `tag` |
| [5](exercises/05-instalando-dependencias/README.md) | Instalando dependências | `WORKDIR`, `RUN pip install`, `requirements.txt` |
| [6](exercises/06-camadas-e-cache/README.md) | Camadas e cache | ordem das instruções, `history` |
| [7](exercises/07-o-que-nao-entra/README.md) | O que não entra na imagem ⏱ | `.dockerignore` |
| [8](exercises/08-abrindo-portas/README.md) | Abrindo portas | `-p`, `EXPOSE`, aba PORTS, `/docs` |
| [9](exercises/09-configuracao-por-ambiente/README.md) | Configuração por ambiente | `ENV`, `-e`, `--env-file`, `exec` |
| [10](exercises/10-editando-ao-vivo/README.md) | Editando ao vivo | bind mount `-v "$PWD:/app"` |
| [11](exercises/11-dados-que-ficam/README.md) | Dados que ficam ⏱ | `docker volume`, `ENTRYPOINT` |
| [12](exercises/12-site-estatico/README.md) | Site estático | `nginx:alpine` + HTML/JS |
| [13](exercises/13-containers-conversando/README.md) | Containers conversando | `network create`, DNS por nome |
| [14](exercises/14-docker-compose/README.md) | Docker Compose | `compose.yaml`, `up -d`, `ps`, `logs`, `down` |
| [15](exercises/15-faxina/README.md) | Faxina ⏱ | `system df`, `prune` |

Os desafios 7, 11 e 15 têm a marca ⏱ porque podem ficar para depois da aula, se faltar tempo. A seção **Missão extra** de cada enunciado é opcional: use-a para praticar mais quando terminar a tarefa principal.

Você vai trabalhar com um **livro de receitas**. Primeiro, um programa Python mostra as receitas no terminal. Depois, uma API fornece esses dados pela rede. Por fim, um site exibe a lista no navegador, e o Docker Compose inicia os containers do site e da API juntos.

## Ao final da aula

1. O desafio 15 limpa o Docker; se ele ficou para depois, `docker ps -a` mostra o que sobrou.
2. **Pare ou exclua o Codespace.** Mesmo parado, ele continua ocupando o armazenamento da franquia gratuita. Ao excluí-lo, você perde os arquivos e as alterações feitas nele. O instalador pode preparar os arquivos iniciais do curso em outro Codespace, mas não recupera o seu trabalho.
3. Para continuar: [Descomplicando Docker](https://livro.descomplicandodocker.com.br/) (livro gratuito, em português) e os guias [Docker concepts](https://docs.docker.com/get-started/docker-concepts/) da documentação oficial.

## Para desenvolver o curso

Os arquivos iniciais dos laboratórios são gerados por `scripts/labs.sh`, e as respostas são verificadas por `scripts/checks.sh`. Quem mantém o curso pode executar os testes em `tests/` com o comando abaixo. Eles usam um container Docker-in-Docker, isto é, com outro serviço Docker dentro dele, e precisam da opção `--privileged`. Os testes executam o `install.sh` e conferem, para cada desafio, se `check.sh` identifica o que falta, orienta sobre respostas incorretas e aprova a solução do gabarito:

```bash
tests/rodar.sh
```

## Licença

[MIT](LICENSE).
