# Guia do aluno

## Antes da aula

1. Siga a seção [Antes da aula](../README.md#antes-da-aula) do README para criar seu Codespace e executar o instalador.
2. Abra um terminal novo, execute `docker run hello-world` e depois `check.sh 00`.
3. Se aparecer uma dica, faça o que ela sugere. Ao pedir ajuda, envie o comando que você executou e a mensagem completa do terminal.
4. Pare seu Codespace em [github.com/codespaces](https://github.com/codespaces), no menu **⋯ → Stop codespace**. No dia da aula, abra o mesmo Codespace para continuar.

## Como acompanhar os exercícios

- Comece pelo slide **Como acompanhar a aula**. Ele apresenta o terminal, o editor e a diferença entre um comando e o conteúdo de um arquivo.
- Siga a trilha principal: **0 → 1 → 2 → 3 → 4 → 5 → 8 → 9 → 10 → 12 → 13 → 14**. Ela inclui o 10 (Editando ao vivo).
- Os exercícios 6, 7, 11, 15, 16 e 17 são opcionais, assim como as seções **Missão extra**. O 16 e o 17 são práticas de Compose para depois da aula. Faça a faxina (15) por último.
- Em cada exercício, leia o objetivo, entre na pasta indicada, execute uma etapa por vez e compare o resultado com o enunciado.
- Nos slides, o `$` marca um comando: copie a linha sem esse símbolo. Os blocos de Dockerfile, Python e YAML vão no editor, no arquivo indicado.
- Salve com **Ctrl+S**, ou **Cmd+S** no Mac, antes de construir uma imagem ou consultar a API.
- Ao terminar, execute `check.sh NN`, trocando `NN` pelo número do exercício. Se aparecer **concluído**, está certo; se aparecerem dicas, elas mostram o que ajustar.

Nos exercícios 6 e 10, você acrescenta uma receita à lista `RECEITAS` em `app.py`. Cole a linha nova antes do `]` que fecha a lista e mantenha as aspas, a vírgula e o alinhamento das outras receitas. Não é preciso saber Python para isso.

## Onde você está trabalhando?

| Lugar | O que fazer ali |
|---|---|
| Terminal do Codespace | Executar `docker`, `cd`, `check.sh` e os demais comandos dos enunciados |
| Terminal dentro do container | Explorar os arquivos do container; no exercício 2, use `exit` para voltar ao Codespace |
| Editor do VS Code | Criar e salvar `Dockerfile`, `compose.yaml` e alterações em `app.py` |
| Navegador | Abrir o endereço da aba **PORTS** e testar a página ou a API |

`pwd` mostra a pasta atual, `ls` lista os arquivos dela, `cd caminho` muda de pasta e `cat arquivo` mostra o conteúdo de um arquivo. `code arquivo` abre o arquivo no editor.

O material do curso fica em `~/devops-docker`, e os arquivos em que você pratica ficam em `~/labs`. O instalador cria o atalho `labs` na pasta onde foi executado, o equivalente a `ln -s ~/labs labs`. O atalho aponta para os mesmos arquivos; não é uma cópia.

## O que cada comando de apoio faz

| Comando | Quando usar |
|---|---|
| `check.sh NN` | Conferir o resultado e receber dicas |
| `setup.sh` | Baixar imagens que faltam e gerar laboratórios ainda inexistentes |
| `reset.sh NN` | Recomeçar um exercício: remove seus recursos Docker e substitui a pasta pelos arquivos iniciais |
| `rede.sh` | Refazer o ajuste de firewall, se a conexão entre containers expirar. O ajuste já roda sozinho no Codespace |

`setup.sh` não mexe nos laboratórios que já existem. Para receber uma versão atualizada dos arquivos iniciais de um exercício, rode o instalador de novo e depois `reset.sh NN`. Antes do `reset.sh`, **guarde as alterações que quiser manter**. Depois, entre novamente na pasta com o `cd` do enunciado.

## Problemas comuns

| O que apareceu | O que você pode fazer |
|---|---|
| `check.sh: command not found` | Abra um terminal novo ou execute `source ~/.bashrc`. No zsh, use `source ~/.zshrc`. |
| `Cannot connect to the Docker daemon` | Espere um minuto após abrir o Codespace e tente `docker version` novamente. Se continuar, pare e reabra o Codespace. |
| `bash: !': event not found` | Use aspas simples por fora do código Python: `docker run python:3.12-slim python -c 'print("Olá, Docker!")'`. Elas impedem que o Bash trate o `!` como expansão de histórico. |
| `unknown flag` ou falta de argumento em `docker run` | Coloque as opções (`-d`, `-p`, `-v`, `--name`) antes do nome da imagem. O que vem depois da imagem é o comando que roda dentro do container. |
| `The container name ... is already in use` | Consulte `docker ps -a`. Remova o container antigo com `docker rm -f` seguido do nome dele (no exemplo da API, `docker rm -f api`) e repita o `docker run` do enunciado. |
| `port is already allocated` | A coluna PORTS de `docker ps` mostra qual container está usando a porta. Remova esse container antigo antes de criar o novo. |
| Container com `Exited (1)` | Rode `docker logs <nome>`, com o nome do container no lugar de `<nome>`. Corrija o erro que aparecer, salve e, se for o caso, reconstrua a imagem. |
| Alteração não aparece na imagem | Salve o arquivo e repita `docker build`. Containers existentes continuam usando a imagem anterior; recrie-os para usar a nova. |
| `docker build` reclama de falta de argumento | Faltou o ponto no final: `docker build -t receitas:1.0 .`. Ele indica a pasta do projeto. |
| Pasta montada vazia ou arquivo ausente | Entre na pasta indicada antes de rodar `docker run -v "$PWD:/app" ...`. `$PWD` é a pasta atual e precisa ser a do laboratório. |
| Pudim não aparece no exercício 10 | Salve `app.py`, confira a montagem com `docker inspect dev` e consulte `docker logs dev` para ver se o programa recarregou ou encontrou um erro de Python. |
| `compose.yaml` inválido | Execute `docker compose config`. Use dois espaços por nível e copie também as linhas abaixo de `depends_on`. |
| Aba PORTS sem a porta esperada | Confira se o container está rodando e se a coluna PORTS de `docker ps` mostra a publicação. No Compose, use `docker compose ps`. |
| Pasta não encontrada depois de `reset.sh` | Execute novamente o `cd` do enunciado; a pasta foi recriada. |
| Containers rodando, mas a conexão entre eles expira (timeout) | Execute `rede.sh` e tente novamente. Ele corrige um bloqueio de firewall que ocorre em alguns Codespaces. |

## Ao terminar

1. A faxina (exercício 15) remove os recursos Docker criados durante a aula. Depois dela, as verificações anteriores só voltam a aprovar se você refizer as tarefas.
2. Pare ou exclua seu Codespace. Parado, ele ainda ocupa armazenamento; excluído, perde os arquivos e as alterações. Guarde o que quiser manter antes de excluí-lo.
3. Para revisar, consulte o [gabarito](gabarito.md). Para continuar estudando, leia [Descomplicando Docker](https://livro.descomplicandodocker.com.br/) ou tente colocar um projeto seu em um container.
