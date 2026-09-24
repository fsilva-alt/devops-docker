# Ementa — Curso de Docker no GitHub Codespaces

| Item | Definição |
|---|---|
| Formato | Aula síncrona via Zoom, com prática no Codespace individual de cada pessoa |
| Duração | 3 horas |
| Turma | Cerca de 100 pessoas |
| Público | Iniciantes, sem experiência prévia com Docker; noções básicas de terminal ajudam |
| Pré-requisitos | Conta GitHub pessoal e navegador atualizado. O Docker já vem no Codespace |
| Preparação | Criar um Codespace em branco, rodar o instalador de uma linha e o `check.sh 00` antes do dia da aula |

## Objetivos de aprendizagem

Ao final, a pessoa deverá ser capaz de:

- explicar o que é um container, a diferença entre imagem e container, e o que o Docker resolve (e não resolve);
- rodar, inspecionar, parar, iniciar e remover containers, lendo os logs deles;
- escrever um `Dockerfile` para um programa Python com dependências, entendendo camadas, cache e `.dockerignore`;
- publicar portas, configurar containers por variáveis de ambiente e acessar a aplicação pelo navegador do Codespace;
- usar bind mounts para desenvolver e volumes para guardar dados;
- colocar um site estático num container nginx;
- fazer containers conversarem por nome numa rede e subir uma aplicação de dois serviços com Docker Compose;
- limpar o que o Docker acumula.

## Conteúdo por módulo

| Módulo | Conteúdo |
|---|---|
| Introdução | O que é um container; breve história; imagem × container; o que o Docker resolve e o que não resolve; Docker ≠ Docker Hub ≠ Docker Desktop; o Docker no Codespace |
| 1. Fundamentos | `docker run`, `ps -a`, `images`; `-it`, `--rm`, `--name`; isolamento do sistema de arquivos; `-d`, `logs`, `stop`, `start`, `rm`, `exec` |
| 2. Dockerfile | `FROM`, `COPY`, `CMD`, `WORKDIR`, `RUN`; `docker build -t`; tags; camadas e cache (ordem das instruções); `docker history`; `.dockerignore` |
| 3. Portas e configuração | Rede do container; `-p fora:dentro`; `EXPOSE`; `0.0.0.0` vs `127.0.0.1`; aba PORTS do Codespace; `ENV`, `-e`, `--env-file` |
| 4. Dados | Camada gravável; bind mount (`-v $PWD:/app`) para desenvolvimento; volumes nomeados (`docker volume`) para dados; `ENTRYPOINT` vs `CMD` |
| 5. Vários containers | Imagens oficiais prontas (nginx); redes definidas pelo usuário e DNS por nome; `compose.yaml`: `services`, `build`, `ports`, `depends_on`, `environment`; `up -d`, `ps`, `logs`, `down` |
| Encerramento | `docker system df`; `container prune`, `image prune`; registries e próximos passos |

O projeto usado do desafio 4 em diante é um **livro de receitas**: um script Python, depois uma API em FastAPI (Python) e um site estático (HTML/JavaScript) servido pelo nginx, que no fim conversam entre si via Compose.

## Cronograma

| Horário | Bloco | Conteúdo |
|---|---|---|
| 0:00–0:12 | Abertura | Logística do Zoom, abrir o Codespace, `check.sh 00` (todos), introdução: o que é um container, história, imagem × container |
| 0:12–0:24 | Módulo 1 | `docker run`, `ps`, `images`; `-it`, `--rm`, `--name`; cada container tem o seu sistema de arquivos; Docker ≠ VM |
| 0:24–0:29 | **Desafio 1** | Olá, container |
| 0:29–0:34 | **Desafio 2** | Dentro do container |
| 0:34–0:39 | Módulo 1b | Ciclo de vida: `-d`, `logs`, `stop`, `start`, `rm`, `exec` |
| 0:39–0:44 | **Desafio 3** | Ciclo de vida |
| 0:44–0:56 | Módulo 2 | Dockerfile: `FROM`, `COPY`, `CMD`, `WORKDIR`, `RUN`; `build -t`; tags; `RUN` no build × `CMD` no run |
| 0:56–1:02 | **Desafio 4** | Meu primeiro Dockerfile |
| 1:02–1:08 | **Desafio 5** | Instalando dependências |
| 1:08–1:13 | Módulo 2b | Camadas, cache e ordem; `.dockerignore`; segredos não entram na imagem |
| 1:13–1:18 | **Desafio 6** | Camadas e cache |
| 1:18–1:22 | **Desafio 7** ⏱ | O que não entra na imagem |
| 1:22–1:32 | Intervalo | |
| 1:32–1:42 | Módulo 3 | Portas: `-p`, `EXPOSE`, `0.0.0.0`, aba PORTS; configuração por ambiente: `ENV`, `-e`, `--env-file` |
| 1:42–1:47 | **Desafio 8** | Abrindo portas |
| 1:47–1:52 | **Desafio 9** | Configuração por ambiente |
| 1:52–2:01 | Módulo 4 | Onde os dados moram: camada gravável, bind mount, volume; `ENTRYPOINT` |
| 2:01–2:06 | **Desafio 10** | Editando ao vivo |
| 2:06–2:11 | **Desafio 11** ⏱ | Dados que ficam |
| 2:11–2:21 | Módulo 5 | Imagens prontas (nginx); redes e DNS por nome; Compose: um arquivo, vários serviços |
| 2:21–2:26 | **Desafio 12** | Site estático |
| 2:26–2:32 | **Desafio 13** | Containers conversando |
| 2:32–2:39 | **Desafio 14** | Docker Compose |
| 2:39–2:47 | Módulo 6 | Onde o disco vai; `prune`; o que não vimos: registries (Docker Hub, GHCR), multi-stage, orquestração; próximos passos |
| 2:47–2:51 | **Desafio 15** ⏱ | Faxina |
| 2:51–3:00 | Encerramento | Perguntas, parar ou excluir o Codespace, leituras sugeridas |

### Distribuição do tempo

| Tipo de bloco | Minutos |
|---|---:|
| Desafios (1 a 15) | 78 |
| Conteúdo expositivo | 71 |
| Abertura (inclui Desafio 0 e introdução) | 12 |
| Intervalo | 10 |
| Encerramento | 9 |
| **Total** | **180** |

### Folga de tempo

O cronograma fecha em exatamente 3 horas. Os desafios **7, 11 e 15** (⏱) são **elásticos**: permanecem na lista, mas viram tarefa pós-aula se houver atraso. Isso libera até 13 minutos, além dos 9 do encerramento.

## Os 16 desafios

Os desafios 4 a 14 ficam em `~/labs/NN-nome/`, cada um com os arquivos de partida (código, `Dockerfile` quando é dado pronto, site). Os desafios 0 a 3 e 15 não têm pasta: acontecem "no Docker inteiro" (containers, imagens e volumes não moram em pasta nenhuma). Os enunciados completos estão em `exercises/`.

| # | Desafio | Tempo | Estado inicial | Tarefa | Verificação |
|---|---|---:|---|---|---|
| 0 | Docker funciona? | 3 | Codespace com Docker | `docker version`, `docker run hello-world`, `docker compose version` | Daemon responde; container do hello-world existe; imagens-base baixadas |
| 1 | Olá, container | 5 | hello-world já rodado | `docker run python:3.12-slim python -c "print(...)"`, `ps -a`, `images` | Existe container do Python com um `print` |
| 2 | Dentro do container | 5 | — | `run -it --rm` (REPL), `run -it --name explorador ... bash`, criar `/marca.txt`, provar o isolamento | `explorador` tem `/marca.txt`; nenhum REPL parado sem `--rm` |
| 3 | Ciclo de vida | 5 | — | `run -d --name relogio`, `logs`, `stop`, `start`, criar e remover `descartavel` | `relogio` rodando, reiniciado e com logs; `descartavel` não existe |
| 4 | Meu primeiro Dockerfile | 6 | `receitas.py` | `FROM`/`COPY`/`CMD`, `build -t receitas:1.0`, `run`; extra: `tag latest` | Imagem existe e imprime o livro |
| 5 | Instalando dependências | 6 | `app.py` (FastAPI), `requirements.txt` | `WORKDIR`, `COPY . .`, `RUN pip install`, `build -t receitas-api:1.0` | Imagem tem FastAPI e `CMD` roda `app.py` |
| 6 | Camadas e cache | 5 | Dockerfile na ordem ingênua | Build, editar código, ver o pip rodar de novo; reordenar; `history` | `COPY requirements.txt` → `RUN pip` → `COPY . .`; `app.py` editado e imagem atualizada |
| 7 | O que não entra na imagem ⏱ | 4 | `.venv/`, `__pycache__/`, `.env`, notas, fotos soltos | Ver o lixo na imagem; criar `.dockerignore`; build | Imagem `receitas-api:1.2` sem o lixo |
| 8 | Abrindo portas | 5 | Dockerfile sem `EXPOSE` | `EXPOSE 8000`, `run -d --name api -p 8001:8000`, `curl`, aba PORTS, `/docs` | `api` rodando, porta 8001→8000, `/receitas` responde |
| 9 | Configuração por ambiente | 5 | `app.py` lê `COZINHA`; Dockerfile sem `ENV` | `ENV` na imagem, `-e` no run, `exec env`; extra: `--env-file` | Imagem tem padrão; `cozinha` roda com outro valor em 8002 |
| 10 | Editando ao vivo | 5 | `app.py` com `reload=True` | `run -d --name dev -p 8003:8000 -v "$PWD:/app"`, editar `app.py` (Pudim), `curl` | `dev` com bind mount; API mostra o Pudim |
| 11 | Dados que ficam ⏱ | 5 | `bloco.py` + Dockerfile com `ENTRYPOINT` | Ver os dados morrerem com o container; `volume create notas`; `-v notas:/dados` | Volume `notas` com ≥ 2 notas |
| 12 | Site estático | 5 | `site/` (HTML, CSS, JS, JSON) | `FROM nginx:alpine`, `COPY site/`, `build -t receitas-web:1.0`, `run -p 8080:80` | `web` rodando; `/`, `/app.js` e `/receitas.json` respondem |
| 13 | Containers conversando | 6 | API + `cliente.py` | `network create cozinha`, `run --network cozinha --name receitas` (sem `-p`), cliente pelo nome | De dentro da rede, `http://receitas:8000/receitas` responde; extra: sem porta publicada |
| 14 | Docker Compose | 7 | `api/` e `web/` (nginx com proxy `/api/`) | Escrever `compose.yaml`, `up -d --build`, `ps`, `logs`; extra: `environment` | Serviços `api` e `web` rodando; `localhost:8090/api/receitas` chega à API |
| 15 | Faxina ⏱ | 4 | Tudo o que a aula criou | `system df`, `stop`, `container prune`, `image prune`; extra: volume, rede e imagens do curso | Nenhum container; nenhuma imagem `<none>` |
