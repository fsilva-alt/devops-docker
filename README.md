# Curso de Docker no GitHub Codespaces

Curso síncrono de 3 horas, do zero, com aula via Zoom e prática no Codespace individual de cada pessoa. Você não instala nada no seu computador: o navegador basta, e o Docker já vem no Codespace.

> **Aluno?** Siga a seção [Antes da aula](#antes-da-aula) agora e, no dia, a [Sequência da aula](#sequência-da-aula).
> **Professor ou monitor?** Veja o [guia do professor](docs/guia-do-professor.md).

## O que você vai aprender

- o que é um container e a diferença entre imagem e container;
- rodar, inspecionar, parar e remover containers, lendo os logs deles;
- escrever um `Dockerfile` para um programa Python com dependências, entendendo camadas, cache e `.dockerignore`;
- publicar portas, configurar por variáveis de ambiente e acessar a aplicação pelo navegador;
- desenvolver com bind mounts e guardar dados em volumes;
- colocar um site estático (HTML/JavaScript) num container nginx;
- fazer containers conversarem por nome e subir dois serviços com Docker Compose;
- limpar o que o Docker acumula.

A ementa completa, com cronograma, está em [docs/ementa.md](docs/ementa.md).

## Antes da aula

Faça isto **pelo menos um dia antes**, para que qualquer problema de acesso apareça com folga.

1. Tenha uma conta no [GitHub](https://github.com) e esteja logado.
2. Crie um Codespace em branco: acesse [github.com/codespaces](https://github.com/codespaces) e clique em **New codespace** com o template **Blank**, ou vá direto em [codespaces/new](https://github.com/codespaces/new). A primeira criação leva de 1 a 3 minutos.
3. Quando o VS Code abrir no navegador, cole no terminal e pressione Enter:

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fsilva-alt/devops-docker/main/install.sh)"
   ```

   O instalador baixa o curso para `~/devops-docker`, baixa as imagens que a aula usa, monta os laboratórios em `~/labs` e termina com a mensagem **"Curso de Docker instalado com sucesso!"**.

4. Abra um terminal novo (ou rode `source ~/.bashrc`), rode o seu primeiro container e confira o ambiente:

   ```bash
   docker run hello-world
   check.sh 00
   ```

   Se o `check.sh 00` aprovar, está tudo pronto. O enunciado do [desafio 0](exercises/00-docker-funciona/README.md) explica o que aconteceu.

5. Pare o Codespace para não gastar sua franquia gratuita: em [github.com/codespaces](https://github.com/codespaces), **⋯ → Stop codespace**. No dia da aula, é só abrir de novo. Tudo continua lá.

## Como o ambiente funciona

| Onde | O quê |
|---|---|
| `~/devops-docker/` | Este repositório: enunciados, scripts e documentos |
| `~/devops-docker/exercises/NN-nome/README.md` | O enunciado de cada desafio |
| `~/labs/NN-nome/` | Os arquivos de partida dos desafios 4 a 14 (código, Dockerfiles, site) |

Os desafios 0 a 3 e 15 não têm pasta: containers e imagens não moram em pasta nenhuma.

Comandos disponíveis no terminal:

| Comando | Faz |
|---|---|
| `check.sh NN` | Verifica o desafio NN e responde ✅ ou uma dica |
| `reset.sh NN` | Recria o desafio NN do zero: apaga a pasta dele **e** os containers, imagens e volumes que ele criou (só dele) |
| `setup.sh` | Baixa imagens e gera os laboratórios que ainda não existem; o instalador já rodou isso |

Dentro da pasta de um laboratório, `check.sh` e `reset.sh` funcionam sem o número. Para ler um enunciado no editor: `code ~/devops-docker/exercises/08-abrindo-portas/README.md`.

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

⏱ = desafio elástico: se a aula atrasar, vira tarefa para depois.

O projeto que você coloca em containers é um **livro de receitas**: começa como um script Python, vira uma API em FastAPI e ganha um site em HTML/JavaScript; no fim, os dois conversam via Compose.

## Ao final da aula

1. O desafio 15 limpa o Docker; se ele ficou para depois, `docker ps -a` mostra o que sobrou.
2. **Pare ou exclua o Codespace.** Um Codespace parado continua ocupando armazenamento da franquia gratuita; um excluído não. Imagens e laboratórios são descartáveis: o instalador recria tudo em outro Codespace a qualquer momento.
3. Para continuar: [Descomplicando Docker](https://livro.descomplicandodocker.com.br/) (livro gratuito, em português) e os guias [Docker concepts](https://docs.docker.com/get-started/docker-concepts/) da documentação oficial.

## Para desenvolver o curso

Esta seção não é para a aula. Os laboratórios são gerados por `scripts/labs.sh` e verificados por `scripts/checks.sh`. A suíte de testes em `tests/` roda num container Docker-in-Docker (precisa de Docker e de `--privileged`): executa o `install.sh` como um aluno faria e, para cada desafio, confere que `check.sh` reprova o estado vazio, reprova respostas erradas com a dica certa e aprova a solução do gabarito:

```bash
tests/rodar.sh
```

## Licença

[MIT](LICENSE).
