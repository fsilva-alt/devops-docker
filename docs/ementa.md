# Ementa — Curso de Docker no GitHub Codespaces

| Item | Definição |
|---|---|
| Formato | Aula ao vivo pelo Zoom, com exercícios no Codespace de cada participante |
| Duração | 3 horas |
| Público | Iniciantes, inclusive pessoas sem experiência com programação, Docker ou terminal |
| Pré-requisitos | Conta GitHub pessoal e navegador atualizado. O Docker já vem no Codespace |
| Preparação | Seguir a seção “Antes da aula” do README: criar um Codespace em branco, executar o instalador e conferir o ambiente com `check.sh 00` |

## Objetivos de aprendizagem

Ao longo dos exercícios, você aprende a:

- explicar o que é um container, a diferença entre imagem e container, e o que o Docker resolve (e não resolve);
- executar, consultar, parar, iniciar e remover containers e ler as mensagens que eles registram (logs);
- escrever um `Dockerfile` para o programa Python fornecido, instalar suas dependências e escolher os arquivos incluídos na imagem;
- entender como a ordem das instruções permite reutilizar etapas da construção (cache);
- publicar portas, definir configurações por variáveis de ambiente e acessar o programa pelo navegador;
- compartilhar pastas com containers usando bind mounts e guardar dados em volumes;
- colocar um site estático num container nginx;
- conectar containers pelo nome em uma rede e iniciar o site e a API com Docker Compose;
- remover recursos que não serão mais usados e liberar espaço.

## Conteúdo por módulo

| Módulo | Conteúdo |
|---|---|
| Introdução | Como usar terminal e editor; como acompanhar os exemplos; o que é um container; breve história; imagem e container; usos e limites do Docker; diferenças entre Docker Engine, Docker Hub e Docker Desktop |
| 1. Fundamentos | `docker run`, `ps -a`, `images`; `-it`, `--rm`, `--name`; isolamento do sistema de arquivos; `-d`, `logs`, `stop`, `start`, `rm`, `exec` |
| 2. Dockerfile | `FROM`, `COPY`, `CMD`, `WORKDIR`, `RUN`; `docker build -t`; tags; camadas e cache (ordem das instruções); `docker history`; `.dockerignore` |
| 3. Portas e configuração | Rede do container; `-p fora:dentro`; `EXPOSE`; `0.0.0.0` vs `127.0.0.1`; aba PORTS do Codespace; `ENV`, `-e`, `--env-file` |
| 4. Dados | Camada gravável; bind mount (`-v $PWD:/app`) para desenvolvimento; volumes nomeados (`docker volume`) para dados; `ENTRYPOINT` vs `CMD` |
| 5. Vários containers | Imagens oficiais prontas (nginx); redes definidas pelo usuário e DNS por nome; `compose.yaml`: `services`, `build`, `ports`, `depends_on`, `environment`; `up -d`, `ps`, `logs`, `down` |
| Encerramento | `docker system df`; `container prune`, `image prune`; registries e próximos passos |

Do exercício 4 em diante, o exemplo é um livro de receitas. Primeiro, um programa Python mostra os dados no terminal. Depois, uma API feita com FastAPI fornece as receitas pela rede. Por fim, um site exibe os dados no navegador, e o Docker Compose inicia os containers do site e da API juntos. O código vem pronto, e os enunciados guiam cada pequena alteração.

## Cronograma

| Horário | Bloco | Conteúdo |
|---|---|---|
| 0:00–0:12 | Abertura | Orientações sobre o Zoom; abrir o Codespace; `check.sh 00`; localizar terminal e editor; introdução a containers e imagens |
| 0:12–0:24 | Módulo 1 | `docker run`, `ps`, `images`; `-it`, `--rm`, `--name`; cada container tem o seu sistema de arquivos; Docker ≠ VM |
| 0:24–0:29 | **Exercício 1** | Olá, container |
| 0:29–0:34 | **Exercício 2** | Dentro do container |
| 0:34–0:39 | Módulo 1b | Ciclo de vida: `-d`, `logs`, `stop`, `start`, `rm`, `exec` |
| 0:39–0:44 | **Exercício 3** | Ciclo de vida |
| 0:44–0:56 | Módulo 2 | Dockerfile: `FROM`, `COPY`, `CMD`, `WORKDIR`, `RUN`; `build -t`; tags; `RUN` no build × `CMD` no run |
| 0:56–1:02 | **Exercício 4** | Meu primeiro Dockerfile |
| 1:02–1:08 | **Exercício 5** | Instalando dependências |
| 1:08–1:13 | Módulo 2b | Camadas, cache e ordem; `.dockerignore`; segredos não entram na imagem |
| 1:13–1:18 | **Exercício 6 · opcional** | Camadas e cache |
| 1:18–1:22 | **Exercício 7 · opcional** | O que não entra na imagem |
| 1:22–1:32 | Intervalo | |
| 1:32–1:42 | Módulo 3 | Portas: `-p`, `EXPOSE`, `0.0.0.0`, aba PORTS; configuração por ambiente: `ENV`, `-e`, `--env-file` |
| 1:42–1:47 | **Exercício 8** | Abrindo portas |
| 1:47–1:52 | **Exercício 9** | Configuração por ambiente |
| 1:52–2:01 | Módulo 4 | Onde os dados ficam guardados: camada gravável, bind mount, volume; `ENTRYPOINT` |
| 2:01–2:06 | **Exercício 10** | Editando ao vivo |
| 2:06–2:11 | **Exercício 11 · opcional** | Dados que ficam |
| 2:11–2:21 | Módulo 5 | Imagens prontas (nginx); redes e DNS por nome; Compose: um arquivo, vários serviços |
| 2:21–2:26 | **Exercício 12** | Site estático |
| 2:26–2:32 | **Exercício 13** | Containers conversando |
| 2:32–2:39 | **Exercício 14** | Docker Compose |
| 2:39–2:47 | Módulo 6 | Onde o disco vai; `prune`; o que não vimos: registries (Docker Hub, GHCR), multi-stage, orquestração; próximos passos |
| 2:47–2:51 | **Exercício 15 · opcional** | Faxina |
| 2:51–3:00 | Encerramento | Perguntas, parar ou excluir o Codespace, leituras sugeridas |

### Distribuição do tempo

| Tipo de bloco | Minutos |
|---|---:|
| Exercícios da trilha principal (1–5, 8–10, 12–14) | 60 |
| Exercícios opcionais (6, 7, 11, 15) ou tempo para tirar dúvidas | 18 |
| Conteúdo expositivo | 71 |
| Abertura (inclui Exercício 0 e introdução) | 12 |
| Intervalo | 10 |
| Encerramento | 9 |
| **Total** | **180** |

### Como organizar sua prática

Dentro das 3 horas há quatro exercícios opcionais: 6, 7, 11 e 15. Os 18 minutos reservados para eles também servem para tirar dúvidas ou terminar etapas anteriores, deixando os opcionais para depois. Mesmo que não os faça na hora, acompanhe as explicações sobre cache, `.dockerignore`, volumes e limpeza, porque elas ajudam a entender os exemplos seguintes. Os 9 minutos finais ficam para perguntas e próximos passos.

A trilha principal é **0 → 1 → 2 → 3 → 4 → 5 → 8 → 9 → 10 → 12 → 13 → 14** e inclui a edição ao vivo com bind mounts. Os opcionais aprofundam otimização, persistência e manutenção. Pular algum deles não atrapalha, porque os laboratórios seguintes já vêm com os arquivos necessários.

## Os 18 exercícios

Os exercícios 4 a 14, 16 e 17 têm arquivos iniciais (código, site e, quando indicado, um `Dockerfile` pronto) em `~/labs/NN-nome/`, onde `NN` é o número de cada um. Os demais, 0 a 3 e 15, usam só comandos do Docker, que funcionam em qualquer pasta. Os enunciados completos estão em `exercises/`.

O 16 e o 17 são opcionais e ficam para depois da aula: somam 12 minutos de prática de Compose, fora do cronograma de 3 horas. Se fizer esses dois, deixe a faxina (15) para depois deles.

| # | Exercício | Tempo | Estado inicial | Tarefa | Verificação |
|---|---|---:|---|---|---|
| 0 | Docker funciona? | 3 | Codespace com Docker | `docker version`, `docker run hello-world`, `docker compose version` | Daemon responde; hello-world existe; imagens-base baixadas; dois containers conversam pelo nome |
| 1 | Olá, container | 5 | hello-world já rodado | `docker run python:3.12-slim python -c "print(...)"`, `ps -a`, `images` | Existe container do Python com um `print` |
| 2 | Dentro do container | 5 | — | Abrir o Python interativo com `run -it --rm`; criar `explorador`, gravar `/marca.txt` e comparar com outro container | `explorador` tem `/marca.txt`; o container do Python interativo foi removido |
| 3 | Ciclo de vida | 5 | — | `run -d --name relogio`, `logs`, `stop`, `start`, criar e remover `descartavel` | `relogio` rodando, reiniciado e com logs; `descartavel` não existe |
| 4 | Meu primeiro Dockerfile | 6 | `receitas.py` | `FROM`, `COPY` e `CMD`; `build -t receitas:1.0`, `run`; extra: `tag latest` | Imagem existe e imprime o livro |
| 5 | Instalando dependências | 6 | `app.py` (FastAPI), `requirements.txt` | `WORKDIR`, `COPY . .`, `RUN pip install`, `build -t receitas-api:1.0` | Imagem tem FastAPI e `CMD` roda `app.py` |
| 6 | Camadas e cache · **opcional** | 5 | Dockerfile copia o código antes de instalar dependências | Construir, editar o código, observar a reinstalação; reordenar; consultar `history` | `COPY requirements.txt` → `RUN pip` → `COPY . .`; `app.py` editado e imagem atualizada |
| 7 | O que não entra na imagem · **opcional** | 4 | Exemplos de arquivos desnecessários: `.venv/`, `__pycache__/`, `.env`, notas e fotos | Consultar os arquivos da imagem, criar `.dockerignore` e reconstruir | Imagem `receitas-api:1.2` sem os cinco itens excluídos |
| 8 | Abrindo portas | 5 | Dockerfile sem `EXPOSE` | `EXPOSE 8000`, `run -d --name api -p 8001:8000`, `curl`, aba PORTS, `/docs` | `api` rodando, porta 8001→8000, `/receitas` responde |
| 9 | Configuração por ambiente | 5 | `app.py` lê `COZINHA`; Dockerfile sem `ENV` | `ENV` na imagem, `-e` no run, `exec env`; extra: `--env-file` | Imagem tem padrão; `cozinha` roda com outro valor em 8002 |
| 10 | Editando ao vivo | 5 | `app.py` com `reload=True` | `run -d --name dev -p 8003:8000 -v "$PWD:/app"`, editar `app.py` (Pudim), `curl` | `dev` com bind mount; API mostra o Pudim |
| 11 | Dados que ficam · **opcional** | 5 | `bloco.py` + Dockerfile com `ENTRYPOINT` | Comparar a remoção de arquivos do container com a preservação de notas no volume; `volume create notas`; `-v notas:/dados` | Volume `notas` com pelo menos 2 notas |
| 12 | Site estático | 5 | `site/` (HTML, CSS, JS, JSON) | `FROM nginx:alpine`, `COPY site/`, `build -t receitas-web:1.0`, `run -p 8080:80` | `web` rodando; `/`, `/app.js` e `/receitas.json` respondem |
| 13 | Containers conversando | 6 | API + `cliente.py` | `network create cozinha`, `run --network cozinha --name receitas` (sem `-p`), cliente pelo nome | De dentro da rede, `http://receitas:8000/receitas` responde; extra: sem porta publicada |
| 14 | Docker Compose | 7 | `api/` e `web/` (nginx com proxy `/api/`) | Escrever `compose.yaml`, `up -d --build`, `ps`, `logs`; extra: `environment` | Serviços `api` e `web` rodando; `localhost:8090/api/receitas` chega à API |
| 16 | Desenvolvimento com Compose · **opcional** | 6 | API com recarga automática e Dockerfile | Compose com bind mount `.:/app`; editar Pudim; `exec` | API mostra Pudim na 8100 sem reconstruir a imagem |
| 17 | Persistência com Compose · **opcional** | 6 | Bloco de notas e Dockerfile | Declarar volume; `run --rm`; `down` e ler novamente | Serviço lê duas notas no volume do projeto |
| 15 | Faxina · **opcional** | 4 | Tudo o que a aula criou | `system df`, `stop`, `container prune`, `image prune`; extra: volume, rede e imagens do curso | Nenhum container; nenhuma imagem `<none>` |
