# Guia do aluno

Use este guia para preparar seu Codespace, acompanhar os desafios e descobrir o próximo passo quando aparecer um erro.

## Antes da aula

1. Siga a seção [Antes da aula](../README.md#antes-da-aula) do README para criar seu Codespace e executar o instalador.
2. Abra um terminal novo, execute `docker run hello-world` e depois `check.sh 00`.
3. Se aparecer uma dica, tente a orientação indicada. Se precisar de ajuda, envie o comando executado e a mensagem completa do terminal.
4. Pare seu Codespace em [github.com/codespaces](https://github.com/codespaces), em **⋯ → Stop codespace**. No dia da aula, abra o mesmo ambiente para continuar.

## Como acompanhar os exercícios

- Comece pelo slide **Como acompanhar a aula**. Ele apresenta o terminal, o editor e a diferença entre um comando e o conteúdo de um arquivo.
- Siga a trilha principal: **0 → 1 → 2 → 3 → 4 → 5 → 8 → 9 → 10 → 12 → 13 → 14**. **Editando ao vivo (10) faz parte da trilha principal.**
- Os desafios **6, 7, 11 e 15** e as seções **Missão extra** são opcionais. Você pode fazê-los depois para aprofundar a prática.
- Em cada desafio, leia o objetivo, entre na pasta indicada, execute uma etapa por vez e compare o resultado com o enunciado.
- Nos slides, o `$` marca um comando: copie a linha sem esse símbolo. Os blocos de Dockerfile, Python e YAML vão no editor, no arquivo indicado.
- Salve com **Ctrl+S** ou **Cmd+S** no Mac antes de construir uma imagem ou consultar a API.
- Ao terminar, execute `check.sh NN`, substituindo `NN` pelo número do desafio. A mensagem **concluído** confirma o resultado; as dicas indicam o que ajustar.

Nos desafios 6 e 10, você acrescenta uma receita à lista `RECEITAS` em `app.py`. Copie a linha antes do `]` final e mantenha as aspas, a vírgula e o alinhamento das outras receitas. Não é preciso conhecer Python para acompanhar essa alteração.

## Onde você está trabalhando?

| Lugar | O que fazer ali |
|---|---|
| Terminal do Codespace | Executar `docker`, `cd`, `check.sh` e os demais comandos dos enunciados |
| Terminal dentro do container | Explorar os arquivos do container; no desafio 2, use `exit` para voltar ao Codespace |
| Editor do VS Code | Criar e salvar `Dockerfile`, `compose.yaml` e alterações em `app.py` |
| Navegador | Abrir o endereço da aba **PORTS** e testar a página ou a API |

`pwd` mostra a pasta atual; `ls` lista seus arquivos; `cd caminho` muda de pasta; `cat arquivo` mostra seu conteúdo. `code arquivo` abre o arquivo no editor.

O material fica em `~/devops-docker`, e sua prática em `~/labs`. O instalador cria o atalho `labs` na pasta de onde você o executou, equivalente a `ln -s ~/labs labs`. Esse atalho aponta para os mesmos arquivos; não é uma cópia.

## O que cada comando de apoio faz

| Comando | Quando usar |
|---|---|
| `check.sh NN` | Conferir o resultado e receber dicas |
| `setup.sh` | Baixar imagens que faltam e gerar laboratórios ainda inexistentes |
| `reset.sh NN` | Recomeçar um desafio: remove seus recursos Docker e substitui a pasta pelos arquivos iniciais |

`setup.sh` preserva laboratórios existentes. Para receber uma versão atualizada dos arquivos iniciais de um desafio, atualize o curso com o instalador e use `reset.sh NN` **depois de guardar as alterações que quiser manter**. Entre novamente na pasta com o `cd` do enunciado.

## Problemas comuns

| O que apareceu | O que você pode fazer |
|---|---|
| `check.sh: command not found` | Abra um terminal novo ou execute `source ~/.bashrc`. No zsh, use `source ~/.zshrc`. |
| `Cannot connect to the Docker daemon` | Espere um minuto após abrir o Codespace e tente `docker version` novamente. Se persistir, pare e reabra o Codespace. |
| `bash: !': event not found` | Use aspas simples ao redor do código Python: `docker run python:3.12-slim python -c 'print("Olá, Docker!")'`. Elas protegem o `!` da expansão de histórico do Bash. |
| `unknown flag` ou falta de argumento em `docker run` | Coloque as opções (`-d`, `-p`, `-v`, `--name`) antes da imagem. Depois dela vem o comando executado no container. |
| `The container name ... is already in use` | Consulte `docker ps -a`. Para refazer o exemplo da API, remova o container com `docker rm -f api` e repita o `docker run` do desafio. Use o nome correspondente ao seu exercício. |
| `network with name cozinha already exists` | A rede já foi criada. Consulte `docker network inspect cozinha` e siga usando-a; `docker ps` lista containers, não redes. |
| `port is already allocated` | Consulte a coluna PORTS de `docker ps` para descobrir quem usa a porta. Remova o container antigo do exercício antes de recriá-lo. |
| Container com `Exited (1)` | Consulte `docker logs <nome>`, substituindo `<nome>` pelo container. Corrija o erro indicado, salve e reconstrua a imagem se necessário. |
| Alteração não aparece na imagem | Salve o arquivo e repita `docker build`. Containers existentes continuam usando a imagem anterior; recrie-os para usar a nova. |
| `docker build` reclama de falta de argumento | Inclua o ponto no final: `docker build -t receitas:1.0 .`. Ele indica a pasta do projeto. |
| Pasta montada vazia ou arquivo ausente | Entre na pasta indicada antes do `docker run -v "$PWD:/app" ...`. `$PWD` precisa apontar para o laboratório. |
| Pudim não aparece no desafio 10 | Salve `app.py`, confira a montagem com `docker inspect dev` e consulte `docker logs dev` para ver se o programa recarregou ou encontrou um erro de Python. |
| `compose.yaml` inválido | Execute `docker compose config`. Use dois espaços por nível e copie também as linhas abaixo de `depends_on`. |
| Aba PORTS sem a porta esperada | Confira se o container está rodando e se a coluna PORTS de `docker ps` mostra a publicação. No Compose, use `docker compose ps`. |
| Pasta não encontrada depois de `reset.sh` | Execute novamente o `cd` do enunciado; a pasta foi recriada. |

### Desafios 13 e 14: a API iniciou, mas não responde pela rede

A mensagem `Uvicorn running on http://0.0.0.0:8000` confirma que o servidor iniciou. Ela não testa a comunicação de outro container até ele. Siga os diagnósticos do [desafio 13](../exercises/13-containers-conversando/README.md#se-a-api-não-responder) ou do [desafio 14](../exercises/14-docker-compose/README.md#se-a-página-não-carregar-as-receitas): eles separam erro no programa, no nome de rede e no caminho entre containers.

Se o teste interno da API funciona, mas pedidos entre containers continuam expirando, execute `check.sh 00`: ele também testa uma rede temporária. Se esse teste falhar, pare e reabra o **mesmo Codespace** para reiniciar seu ambiente Docker e repita a verificação. Se persistir, envie as saídas do teste e dos logs ao pedir ajuda. Aumentar o tempo de espera ou acrescentar `EXPOSE` não corrige uma rede sem comunicação.

## Ao terminar

1. Use o desafio 15 quando quiser remover os recursos Docker criados nos exercícios. As verificações anteriores deixarão de aprovar até você refazê-los.
2. Pare ou exclua seu Codespace. Parado, ele ainda ocupa armazenamento; excluído, perde os arquivos e as alterações. Guarde o que quiser manter antes de excluí-lo.
3. Para revisar, consulte o [gabarito](gabarito.md). Para continuar estudando, leia [Descomplicando Docker](https://livro.descomplicandodocker.com.br/) ou tente colocar um projeto seu em um container.
