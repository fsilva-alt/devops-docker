# Curso de Docker no GitHub Codespaces

Aula ao vivo de 3 horas, pelo Zoom, com exercícios feitos no navegador. O ambiente é o GitHub Codespaces, um computador Linux acessado pela internet que já vem com editor de arquivos, terminal e Docker. Cada pessoa recebe o seu, chamado **Codespace**.

Não é preciso ter experiência com programação ou Docker. Os programas dos exercícios já vêm prontos: você aprende a executá-los em containers e faz pequenas alterações seguindo os exemplos.

Comece por [Antes da aula](#antes-da-aula) e depois siga a [Sequência da aula](#sequência-da-aula). O [guia do aluno](docs/guia-do-aluno.md) tem dicas para acompanhar os exercícios e resolver os problemas mais comuns.

## O que você vai aprender

- entender o que é um container: um ambiente isolado para executar um programa;
- criar containers a partir de imagens, que reúnem o programa e os arquivos necessários para executá-lo;
- iniciar, parar e remover containers e ler as mensagens que o programa escreve enquanto roda, chamadas logs;
- escrever um `Dockerfile`, o arquivo com as instruções para construir uma imagem;
- acessar um programa pelo navegador e ajustar suas configurações;
- compartilhar pastas com um container e guardar dados mesmo depois de removê-lo;
- executar um site e uma API, que fornece dados para outros programas;
- usar o Docker Compose para iniciar o site e a API juntos;
- remover os recursos criados durante a aula e liberar espaço.

A ementa completa, com cronograma, está em [docs/ementa.md](docs/ementa.md).

## Antes da aula

Faça esta preparação **pelo menos um dia antes**, para ter tempo de resolver algum problema de acesso.

1. Crie uma conta no [GitHub](https://github.com), se ainda não tiver uma, e entre nela.
2. Crie um Codespace em branco: em [github.com/codespaces](https://github.com/codespaces), escolha o modelo **Blank** (em branco). Outro caminho é a página [codespaces/new](https://github.com/codespaces/new). Na primeira vez, a criação costuma levar de 1 a 3 minutos.
3. O editor VS Code abre no navegador. Nele, abra o menu **Terminal → New Terminal** (novo terminal). O terminal é a área onde você digita comandos para o computador executar. Cole nele a linha abaixo e pressione Enter:

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fsilva-alt/devops-docker/main/install.sh)"
   ```

   Esse comando baixa e executa o instalador do curso, que salva o material em `~/devops-docker`, baixa as imagens usadas na aula e prepara os arquivos dos exercícios em `~/labs` (o `~` representa sua pasta pessoal no Codespace). O instalador também cria um atalho `labs` na pasta em que foi executado, para você chegar a esses arquivos pelo explorador do VS Code. Espere aparecer a mensagem **"Curso de Docker instalado com sucesso!"**.

4. Abra outro terminal pelo menu **Terminal → New Terminal** e execute os comandos abaixo, um por vez, pressionando Enter depois de cada linha:

   ```bash
   docker run hello-world
   check.sh 00
   ```

   O primeiro executa um container de teste; o segundo confere se o ambiente está pronto. Se aparecer **concluído**, está tudo certo. Se aparecer uma dica, faça o que ela sugere e tente de novo. O [exercício 0](exercises/00-docker-funciona/README.md) explica cada etapa.

5. Pare o Codespace para não gastar sua franquia gratuita: em [github.com/codespaces](https://github.com/codespaces), use **⋯ → Stop codespace**. No dia da aula, abra o mesmo Codespace e continue de onde parou.

## Como o ambiente funciona

### Primeiros passos no terminal e no editor

- **Executar um comando:** copie a linha para o terminal e pressione Enter. Espere um comando terminar antes de digitar o próximo. Alguns programas ficam rodando até você interrompê-los; quando for assim, o enunciado explica como sair.
- **Ler os exemplos:** comandos vão no terminal. Blocos marcados como `Dockerfile`, Python ou YAML vão no arquivo indicado pelo enunciado. Nos slides, o `$` no início da linha marca um comando e não deve ser copiado. Linhas que começam com `#` são comentários.
- **Entrar em uma pasta:** digite `cd` e o caminho, como em `cd ~/labs/04-meu-primeiro-dockerfile`. `pwd` mostra em que pasta você está, `ls` lista o que há nela e `cat nome-do-arquivo` mostra o conteúdo de um arquivo no terminal.
- **Abrir ou criar um arquivo:** dentro da pasta do exercício, digite, por exemplo, `code Dockerfile`. O VS Code abre o arquivo para edição; se ele ainda não existir, será criado quando você salvar. Salve com **Ctrl+S**, ou **Cmd+S** no Mac.
- **Usar os nomes dos exemplos:** use os mesmos nomes de arquivos, imagens e containers dos enunciados, porque a verificação procura exatamente esses nomes.

Nos exemplos genéricos, troque `NN` pelo número do exercício; para o 5, por exemplo, `check.sh NN` vira `check.sh 05`. Do mesmo modo, `<nome>` marca um valor que você substitui, e os sinais `<` e `>` não entram no comando. Nas tabelas de referência, `[comando]` indica uma parte opcional e `…` indica um exemplo abreviado. Para executar, use as linhas completas da seção **Tarefa**.

### Onde ficam os arquivos

| Onde | O quê |
|---|---|
| `~/devops-docker/` | Este repositório: enunciados, scripts e documentos |
| `~/devops-docker/exercises/NN-nome/README.md` | O enunciado de cada exercício |
| `~/labs/NN-nome/` | Os arquivos de partida dos exercícios 4 a 14, 16 e 17 (código, Dockerfiles, site) |

Os exercícios 0 a 3 e 15 não têm pasta própria. Os comandos deles funcionam em qualquer pasta do terminal, porque só consultam ou alteram o que o Docker gerencia.

Comandos disponíveis no terminal:

| Comando | Faz |
|---|---|
| `check.sh NN` | Confere o resultado do exercício: mostra ✅ quando está concluído ou dá dicas do que ajustar |
| `reset.sh NN` | Recomeça o exercício: apaga as alterações na pasta dele e remove os containers, imagens, volumes e redes que ele cria |
| `setup.sh` | Baixa as imagens e gera os laboratórios que ainda não existem. O instalador já faz isso |
| `rede.sh` | Corrige um bloqueio de firewall de alguns Codespaces que faz a conexão entre containers expirar. Já roda sozinho na instalação, no `check.sh` e a cada terminal novo |

Dentro da pasta de um laboratório, `check.sh` e `reset.sh` funcionam sem o número. Depois de um `reset.sh`, entre de novo na pasta com o `cd` do enunciado antes de continuar. Para abrir um enunciado no editor, use, por exemplo, `code ~/devops-docker/exercises/08-abrindo-portas/README.md`.

## Sequência da aula

| # | Exercício | Tema |
|---|---|---|
| [0](exercises/00-docker-funciona/README.md) | Docker funciona? | `docker version`, `run hello-world` (antes da aula) |
| [1](exercises/01-ola-container/README.md) | Olá, container | `docker run`, `ps -a`, `images`; imagem × container |
| [2](exercises/02-dentro-do-container/README.md) | Dentro do container | `-it`, `--rm`, `--name`; cada container tem o seu sistema de arquivos |
| [3](exercises/03-ciclo-de-vida/README.md) | Ciclo de vida | `-d`, `logs`, `stop`, `start`, `rm` |
| [4](exercises/04-meu-primeiro-dockerfile/README.md) | Meu primeiro Dockerfile | `FROM`, `COPY`, `CMD`, `build -t`, `tag` |
| [5](exercises/05-instalando-dependencias/README.md) | Instalando dependências | `WORKDIR`, `RUN pip install`, `requirements.txt` |
| [6](exercises/06-camadas-e-cache/README.md) | Camadas e cache · **opcional** | ordem das instruções, `history` |
| [7](exercises/07-o-que-nao-entra/README.md) | O que não entra na imagem · **opcional** | `.dockerignore` |
| [8](exercises/08-abrindo-portas/README.md) | Abrindo portas | `-p`, `EXPOSE`, aba PORTS, `/docs` |
| [9](exercises/09-configuracao-por-ambiente/README.md) | Configuração por ambiente | `ENV`, `-e`, `--env-file`, `exec` |
| [10](exercises/10-editando-ao-vivo/README.md) | Editando ao vivo | bind mount `-v "$PWD:/app"` |
| [11](exercises/11-dados-que-ficam/README.md) | Dados que ficam · **opcional** | `docker volume`, `ENTRYPOINT` |
| [12](exercises/12-site-estatico/README.md) | Site estático | `nginx:alpine` + HTML/JS |
| [13](exercises/13-containers-conversando/README.md) | Containers conversando | `network create`, DNS por nome |
| [14](exercises/14-docker-compose/README.md) | Docker Compose | `compose.yaml`, `up -d`, `ps`, `logs`, `down` |
| [16](exercises/16-compose-desenvolvimento/README.md) | Desenvolvimento com Compose · **opcional** | bind mount em YAML, recarga do código, `compose exec` |
| [17](exercises/17-compose-persistencia/README.md) | Persistência com Compose · **opcional** | volumes nomeados, `compose run --rm`, `down` × `down -v` |
| [15](exercises/15-faxina/README.md) | Faxina · **opcional** | `system df`, `prune` |

A trilha principal é **0 → 1 → 2 → 3 → 4 → 5 → 8 → 9 → 10 → 12 → 13 → 14**, e o 10 (Editando ao vivo) faz parte dela. Ela vai dos primeiros containers até o site e a API rodando juntos com Compose. Os exercícios 6, 7, 11, 15, 16 e 17 são opcionais, e a seção **Missão extra** de cada enunciado também. O 16 e o 17 são práticas de Compose para depois da aula, com arquivos próprios. Faça a **faxina (15) por último**, depois das práticas que escolher.

O exemplo que acompanha a aula é um livro de receitas. Primeiro, um programa Python mostra as receitas no terminal. Depois, uma API fornece esses dados pela rede. Por fim, um site exibe a lista no navegador, e o Docker Compose inicia os containers do site e da API juntos.

## Ao final da aula

1. Se ainda não fez a faxina (exercício 15), `docker ps -a` mostra os containers que sobraram.
2. **Pare ou exclua o Codespace.** Mesmo parado, ele ocupa armazenamento da franquia gratuita. Se você excluí-lo, perde os arquivos e as alterações feitas nele. O instalador consegue preparar os arquivos iniciais do curso em outro Codespace, mas não recupera o seu trabalho.
3. Para continuar estudando: o livro gratuito [Descomplicando Docker](https://livro.descomplicandodocker.com.br/), em português, e os guias [Docker concepts](https://docs.docker.com/get-started/docker-concepts/) da documentação oficial.

## Para desenvolver o curso

`scripts/labs.sh` gera os arquivos iniciais dos laboratórios, e `scripts/checks.sh` verifica as respostas. Os testes ficam em `tests/` e rodam com o comando abaixo. Eles usam um container Docker-in-Docker, isto é, um container com outro Docker dentro, e precisam da opção `--privileged`. Os testes executam o `install.sh` e, para cada exercício, conferem se o `check.sh` aponta o que falta, orienta diante de respostas erradas e aprova a solução do gabarito:

```bash
tests/rodar.sh
```

## Licença

[MIT](LICENSE).
