# Guia do professor

Orientações para preparar e conduzir a aula, entender os scripts do curso e ajudar a turma quando surgir um problema.

## Antes do evento

- [ ] Garantir que o repositório `fsilva-alt/devops-docker` está público, com o `install.sh` na branch `main` (é dele que o `curl` do instalador lê).
- [ ] Testar num Codespace em branco novo: rodar a linha do instalador, o `check.sh 00`, cronometrar os 16 desafios e, principalmente, conferir a aba **PORTS** (desafios 8, 12 e 14): o botão de globo abre o endereço `https://<codespace>-8001.app.github.dev`.
- [ ] Pedir aos alunos que sigam a seção "Antes da aula" do README **pelo menos um dia antes** e parem o Codespace ao terminar. O instalador baixa cerca de 150 MB de imagens; fazer isso com antecedência evita esperar pelos downloads durante a aula.
- [ ] Combinar com os monitores: sugestão de 1 monitor para cada 25 pessoas.
- [ ] Preparar o Zoom: chat liberado, um monitor de olho no chat, salas simultâneas opcionais para atendimento individual.

## Como o ambiente funciona por dentro

| Peça | O que faz |
|---|---|
| `install.sh` | O que o aluno roda via `sh -c "$(curl ...)"` num Codespace em branco: clona o curso em `~/devops-docker`, roda o `setup.sh`, coloca `scripts/` no `PATH` do bash e do zsh e mostra a mensagem de sucesso. Idempotente; rodar de novo atualiza o curso |
| `scripts/setup.sh` | Confere que o daemon responde, baixa as imagens-base (`hello-world`, `alpine`, `python:3.12-slim`, `nginx:alpine`), **aquece o cache de build** (constrói e descarta uma imagem com o `pip install` do FastAPI, para os builds da aula levarem segundos) e gera as pastas dos labs 04–14 em `~/labs`. Idempotente; `--force` regenera tudo |
| `scripts/labs.sh` | Uma função `gerar_NN` por desafio com pasta (o código, o `Dockerfile` quando é dado pronto, o site) e uma `limpar_NN` por desafio, que remove os containers, imagens, volumes e redes que ele pede para criar |
| `scripts/checks.sh` | Uma função `verificar_NN` por desafio; cada falha vem com uma dica. Inspeciona o Docker (`docker inspect`, `docker port`, `docker compose ps`) e faz `curl localhost:<porta>` |
| `scripts/check.sh NN` | Roda a verificação. Sai com 0 quando concluído |
| `scripts/reset.sh NN` | Roda `limpar_NN` e regenera **só** o lab NN |
| `tests/rodar.sh` | Roda `tests/solucoes.sh` num container Docker-in-Docker (`--privileged`): instala como um aluno, resolve todos os desafios e confere que a verificação reprova antes e aprova depois |

O que os alunos criam tem nomes fixos, que as verificações procuram:

| Desafio | Containers | Imagens | Outros |
|---|---|---|---|
| 2 | `explorador` | | |
| 3 | `relogio`, `descartavel` (removido) | | |
| 4 | | `receitas:1.0` (extra: `latest`) | |
| 5–7 | | `receitas-api:1.0`, `1.1`, `1.2` | |
| 8 | `api` (8001→8000) | `receitas-api:1.3` | |
| 9 | `cozinha` (8002→8000) | `receitas-api:1.4` | `cozinha.env` |
| 10 | `dev` (8003→8000, bind mount) | `receitas-api:1.5` | |
| 11 | | `bloco:1.0` | volume `notas` |
| 12 | `web` (8080→80) | `receitas-web:1.0` | |
| 13 | `receitas` (sem porta) | `receitas-api:1.6` | rede `cozinha` |
| 14 | `14-docker-compose-api-1`, `-web-1` (8090→80) | construídas pelo Compose | rede `14-docker-compose_default` |

Cada desafio usa uma porta de fora diferente, para que os containers dos desafios anteriores possam continuar rodando. Os labs ficam **fora** do repositório do curso (`~/labs`) para o aluno poder rodar `docker build .` sem levar o curso inteiro no contexto.

## Condução da aula

### Para uma turma sem experiência prévia

- Comece pelo slide **Como acompanhar a aula**. Mostre onde ficam o terminal e o editor, como executar uma linha e como salvar um arquivo.
- Explique `cd`, `pwd`, `ls` e `cat` quando aparecerem. Ao usar `$` nos slides, avise que o símbolo marca um comando e não deve ser copiado.
- Diga onde cada ação acontece: no terminal do Codespace, dentro do container, no editor ou no navegador. No desafio 2, mostre a mudança do prompt e a volta ao Codespace após `exit`.
- Nos desafios 6 e 10, mostre onde começa e termina a lista `RECEITAS`. Acrescente a linha com a turma, mantendo aspas, vírgula e alinhamento. O objetivo é aprender Docker, sem exigir que a pessoa já saiba Python.
- Explique o resultado esperado antes de executar. Quando um erro fizer parte do exercício, como a ausência de `/marca.txt` em outro container, avise que ele é esperado e o que demonstra.
- Evite descrever uma etapa como “óbvia”, “mágica” ou “só fazer isso”. Mostre a ação e reserve tempo para quem ainda está se orientando na tela.

### Ritmo

- Anuncie cada desafio com o número e o horário de término. Peça que sinalizem no chat com ✅ quando `check.sh NN` aprovar.
- Quando cerca de 70% sinalizarem, avise que falta 1 minuto e siga. Quem não terminou recebe ajuda de um monitor enquanto a aula continua; quem terminou pode fazer a missão extra, que é opcional.
- Pontos de corte: o **Desafio 7** (antes do intervalo), o **Desafio 11** (fim do módulo de dados) e o **Desafio 15** (fim). Todos viram tarefa de casa sem prejudicar os seguintes.
- **O desafio 15 apaga tudo.** Só anuncie depois do 14 e avise que `check.sh` dos anteriores vai voltar a reprovar.

### Compartilhamento de tela

Use os slides para apresentar o conceito e demonstre a tarefa no seu Codespace. Mantenha o texto do terminal legível e mostre o comando antes de executá-lo. Um segundo terminal com `watch docker ps`, ou uma consulta a `docker ps` após cada ação, ajuda a turma a acompanhar as mudanças. Nos desafios 8, 12 e 14, mostre com calma a aba **PORTS**, o número da porta e o ícone de globo que abre o navegador.

### O que dizer antes de cada bloco

- **Desafio 1:** "`docker run` sempre cria um container novo. Vamos acumular vários parados de propósito; no fim da aula a gente limpa."
- **Desafio 3:** avise que o `docker stop` do relógio demora 10 segundos e por quê (o `sh` ignora o SIGTERM). Não é travamento.
- **Desafio 5:** a primeira construção pode levar 20–30 s se o cache preparado pelo instalador não estiver disponível. Explique que `pip install` instala as dependências na imagem, não diretamente no Codespace.
- **Desafio 10:** depois de salvar `app.py`, mostre a mensagem *Reloading...* em `docker logs dev`. Relacione a alteração do arquivo, a recarga do programa e a nova resposta da API.
- **Desafio 14:** explique que os espaços no início das linhas organizam o YAML. Use dois espaços por nível, nunca Tab, e mostre o alinhamento de `build` e `environment` na missão extra.

## Problemas comuns

| Sintoma | Causa | Solução |
|---|---|---|
| `check.sh: command not found` | Terminal aberto antes de o instalador mexer no `.bashrc`/`.zshrc` | `source ~/.bashrc` (ou `~/.zshrc`), ou abrir um terminal novo; em último caso `bash ~/devops-docker/scripts/check.sh NN` |
| `Cannot connect to the Docker daemon` | Codespace recém-aberto; o daemon ainda está subindo | Esperar um minuto e tentar de novo. Se persistir: `sudo service docker start` ou recarregar a janela do Codespace |
| Instalador falhou no `curl` | Sem rede, ou URL digitada errada | Conferir a linha; se persistir, `git clone https://github.com/fsilva-alt/devops-docker ~/devops-docker && bash ~/devops-docker/install.sh` |
| `docker: 'run' requires at least 1 argument` ou `unknown flag` | Opções depois do nome da imagem | Tudo o que é do `docker run` (`-d`, `-p`, `-v`, `-e`, `--name`) vem **antes** da imagem; o que vem depois é o comando de dentro |
| `The container name "/api" is already in use` | Rodou o `docker run` duas vezes com o mesmo `--name` | `docker rm -f api` e rodar de novo |
| `port is already allocated` | Outra coisa na mesma porta de fora (um container antigo, outro desafio) | `docker ps` para achar quem; ou trocar a porta de fora |
| `curl: (56) Recv failure` ou `Empty reply` | O programa escuta em `127.0.0.1` dentro do container | Tem de ser `0.0.0.0` (os `app.py` do curso já são) |
| Container `Exited (1)` logo depois do `run -d` | O programa encontrou um erro ao iniciar | Consultar `docker logs <nome>` para ler o erro, corrigir o arquivo, reconstruir a imagem se necessário e recriar o container |
| A imagem não contém a alteração | O arquivo foi editado depois da construção | Salvar e construir de novo com a mesma tag; a verificação compara o arquivo da pasta com o de dentro da imagem |
| `docker build` pede `.` | Faltou o contexto | O ponto no final é obrigatório: `docker build -t nome .` |
| `-v "$PWD:/app"` monta pasta vazia | Rodou de outra pasta | `cd ~/labs/10-editando-ao-vivo` antes; `$PWD` precisa ser a pasta do desafio |
| Uvicorn não recarrega no desafio 10 | O bind mount está certo, mas o arquivo não foi salvo | Salvar no VS Code (`Ctrl+S`); conferir `docker logs dev` |
| `compose.yaml` inválido | Tabs ou indentação errada | `docker compose config` aponta a linha; usar dois espaços |
| `502 Bad Gateway` em `localhost:8090/api/receitas` | O serviço da API não se chama `api`, ou ainda está subindo | O `nginx.conf` repassa para `http://api:8000`; conferir o nome do serviço no `compose.yaml` e `docker compose logs api` |
| Aba PORTS não mostra a porta | O container ainda não subiu, ou subiu sem `-p` | `docker ps` mostra a coluna PORTS; se vazia, faltou o `-p` |
| A pessoa não sabe em qual etapa está | Arquivos e containers podem estar em etapas diferentes | Conferir o resultado de `check.sh NN`. Se for necessário recomeçar, explicar que `reset.sh NN` apaga as alterações do desafio, remove seus recursos e recria a pasta |
| Pasta do lab sumiu / `No such file or directory` | Rodou `reset.sh` de dentro da pasta | `cd` de novo para a pasta |
| Codespace lento ou sem disco | Muitas imagens e containers acumulados | `docker system df`; `docker container prune` e `docker image prune` (é o desafio 15) |
| Tudo sumiu depois de reabrir | Codespace foi **excluído** (não só parado) | Criar de novo e rodar o instalador; imagens e labs são recriados |

## Ajustes fáceis

- **Mudar o tema (receitas):** só `scripts/labs.sh`. As verificações dependem de alguns textos (`Bolo de cenoura`, `Pudim`, `Livro de receitas`, `Cozinha da Vovó`); procure em `scripts/checks.sh` antes de trocar.
- **Trocar o framework Python:** `app_py` e `requirements_txt` em `labs.sh`; a verificação do desafio 5 importa `fastapi` e `uvicorn` (`checks.sh`). Mantenha a porta 8000 ou ajuste `dockerfile_api`, `nginx_conf`, `cliente_py`, as verificações 8–14 e os enunciados.
- **Adicionar um desafio:** acrescente o nome em `LAB_NOMES` (`scripts/lib.sh`), uma função `gerar_NN` e uma `limpar_NN` em `labs.sh`, uma `verificar_NN` em `checks.sh`, o enunciado em `exercises/` e um bloco em `tests/solucoes.sh`. Ajuste `ULTIMO_LAB_COM_PASTA` se o desafio tiver pasta, e as listas `*_DO_CURSO` em `lib.sh` com o que ele cria.
- **Rodar os testes:** `tests/rodar.sh` (precisa de Docker com `--privileged`). Rode sempre que mexer em `labs.sh` ou `checks.sh`. A primeira execução baixa as imagens dentro do container de teste; as seguintes usam o volume `curso-docker-testes-cache`.

## Encerramento

1. `check.sh 15` (ou, se o 15 virou tarefa de casa, `docker ps` para mostrar o que ficou).
2. Parar ou excluir o Codespace. Reforce: **parado ainda consome armazenamento**; excluído perde os arquivos e as alterações. O instalador recria o material inicial, mas não recupera o trabalho feito pela pessoa.
3. O que não vimos e vale citar: registries (`docker push` para o Docker Hub ou o GitHub Container Registry), *multi-stage builds* para imagens menores, usuário não-root no container, e orquestração (Kubernetes) quando são muitos containers em muitas máquinas.
4. Próximos passos sugeridos: [Descomplicando Docker](https://livro.descomplicandodocker.com.br/) (livro gratuito, em português), os guias [Docker concepts](https://docs.docker.com/get-started/docker-concepts/) da documentação oficial (em inglês, curtos e práticos) e colocar em container um projeto próprio.
