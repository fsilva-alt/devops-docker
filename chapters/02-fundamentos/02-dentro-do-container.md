---
duration: 5
---

# Dentro do container

{.lead}
Digitar comandos dentro de um container, criar um arquivo nele e ver que esse arquivo **não aparece em outro container** criado a partir da mesma imagem.

`docker run -it --rm` `docker run -it --name` `exit` `docker start -ai`

::::columns
:::card Onde fazer
No terminal do Codespace, em **qualquer pasta**. Quem cuida dos containers e das imagens é o Docker, então estes comandos não dependem da pasta em que você está.
:::
:::card Para este exercício
`⏱ tempo`
: 5 min

`parte`
: Fundamentos

`verificação`
: `check.sh 02`
:::
::::

<p class="eyebrow">Conceito</p>

## Cada container, seu sistema de arquivos

::::columns
:::column
<div class="layers"><div class="cap">container "explorador"</div><div class="stk"><div class="layer rw"><b>explorador · camada gravável</b><small>/marca.txt está aqui</small></div><div class="layer dim"><b>python:3.12-slim</b><small>só leitura</small></div></div></div>
:::
:::column
<div class="layers"><div class="cap">docker run --rm python:3.12-slim cat /marca.txt</div><div class="stk"><div class="layer rw"><b>outro container · camada gravável</b><small>vazia: /marca.txt não existe</small></div><div class="layer dim"><b>python:3.12-slim</b><small>a mesma imagem, compartilhada</small></div></div></div>
:::
::::

:::::columns
::::column
:::card As opções de hoje
| Opção | Efeito |
| --- | --- |
| `-i` | envia o que você digita para o programa no container |
| `-t` | dá um terminal ao programa; as duas opções costumam vir juntas, como -it |
| `--rm` | remove o container assim que o programa termina; bom para testes rápidos |
| `--name x` | dá um nome ao container, no lugar do nome aleatório; facilita os comandos seguintes |
:::
::::
::::column
:::note Parar e remover são ações diferentes.
Sem `--rm`, o container fica parado depois do `exit`, com os arquivos guardados. `docker start -ai explorador` inicia o mesmo container e liga o terminal a ele de novo.
:::

:::note
**Para sair neste exercício:** use `exit()` no Python e `exit` no Bash. Para sair de um container interativo sem encerrá-lo, pressione <kbd>Ctrl+P</kbd> e depois <kbd>Ctrl+Q</kbd>.
:::
::::
:::::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker run -it --rm <imagem> bash` | abre o Bash em um container temporário, se a imagem tiver Bash |
| `docker run -it --name <nome> <imagem> <cmd>` | interativo e com nome; o container continua existindo depois que você sai |
| `docker start -ai <nome>` | inicia um container parado e liga o terminal a ele |
| `docker exec -it <nome> bash` | abre outro Bash em um container que já está rodando (exercício 9) |
| `docker cp <nome>:/arquivo .` | copia um arquivo de dentro do container (mesmo parado) |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [O que é um container?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-container/)<small>documentação oficial · em inglês</small>
- [Comando · docker run](https://docs.docker.com/reference/cli/docker/container/run/)<small>-d, -it, --rm, --name, -p, -e, -v, --network</small>
- [Comando · docker start](https://docs.docker.com/reference/cli/docker/container/start/)<small>-ai</small>
- [Comando · docker exec](https://docs.docker.com/reference/cli/docker/container/exec/)
- [Comando · docker cp](https://docs.docker.com/reference/cli/docker/container/cp/)
:::

<p class="eyebrow">Tarefa · 5 min</p>

## O exercício

:::steps
1. Abra o Python interativo. Quando aparecer `>>>`, digite `import platform; platform.platform()` para ver informações do sistema. Saia com `exit()`. De volta ao Codespace, `docker ps -a` confirma que `--rm` removeu esse container.

   ```console
   $ docker run -it --rm python:3.12-slim
   ```

2. Abra o **Bash** em outro container, agora com o nome `explorador` e sem `--rm`. O Bash é um *shell*, um programa que interpreta os comandos do terminal. Depois da primeira linha, os comandos rodam **dentro do container**:

   ```console
   $ docker run -it --name explorador python:3.12-slim bash
   $ cat /etc/os-release
   $ ls /
   $ hostname
   $ python --version
   ```

3. Ainda dentro do container, crie um arquivo e saia. `echo` produz o texto, e `>` grava esse texto no arquivo:

   ```console
   $ echo "eu estive aqui" > /marca.txt
   $ exit
   ```

4. De volta ao Codespace, tente ler o arquivo em **outro** container da mesma imagem. O erro *No such file or directory* é esperado, porque o arquivo só existe no `explorador`.

   ```console
   $ docker run --rm python:3.12-slim cat /marca.txt
   ```
:::

::::columns
:::card Verificação
```console
$ check.sh 02
```

Rode no terminal do Codespace, fora do container. A verificação procura o arquivo no `explorador` e avisa se o container do Python interativo não foi removido.
:::
:::card Missão extra
```console
$ docker start -ai explorador
$ cat /marca.txt
$ exit
```

O arquivo continua lá. Parar um container preserva os arquivos dele. Removê-lo com `docker rm` apaga esses arquivos.
:::
::::
