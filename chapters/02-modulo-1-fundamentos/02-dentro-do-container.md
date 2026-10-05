---
duration: 5
---

# Dentro do container

{.lead}
Digitar comandos dentro de um container e criar um arquivo nele. Depois, verificar que esse arquivo **não aparece em outro container** criado a partir da mesma imagem.

`docker run -it --rm` `docker run -it --name` `exit` `docker start -ai`

::::columns
:::card Onde fazer
No terminal do Codespace, em **qualquer pasta**. Estes comandos usam recursos gerenciados pelo Docker e não dependem de arquivos da pasta atual.
:::
:::card Para este desafio
`⏱ tempo`
: 5 min

`módulo`
: Módulo 1 · Fundamentos

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
| `-i` | permite enviar o que você digita para o programa no container |
| `-t` | fornece um terminal para essa interação; aqui, usamos as duas opções juntas: -it |
| `--rm` | remove o container assim que ele terminar. Ideal para experiências |
| `--name x` | nome fixo em vez de um aleatório; facilita todos os comandos seguintes |
:::
::::
::::column
:::note Parar e remover são ações diferentes.
Sem `--rm`, sair com `exit` para o container e mantém seus arquivos. `docker start -ai explorador` inicia o mesmo container e permite interagir com ele novamente.
:::

:::note
**Para sair neste exercício:** use `exit()` no Python e `exit` no Bash. Para desconectar o terminal sem parar um container interativo, use <kbd>Ctrl+P</kbd> e depois <kbd>Ctrl+Q</kbd>.
:::
::::
:::::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker run -it --rm <imagem> bash` | abre o Bash, se disponível na imagem, em um container temporário |
| `docker run -it --name <nome> <imagem> <cmd>` | interativo, com nome, e fica depois de sair |
| `docker start -ai <nome>` | inicia um container parado e permite interagir com ele pelo terminal |
| `docker exec -it <nome> bash` | abre outro Bash em um container que já está rodando (desafio 9) |
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

## O desafio

:::steps
1. Abra o Python interativo. Quando aparecer `>>>`, digite `import platform; platform.platform()` para ver informações do sistema. Saia com `exit()`. De volta ao Codespace, `docker ps -a` confirma que `--rm` removeu esse container.

   ```console
   $ docker run -it --rm python:3.12-slim
   ```

2. Abra o **Bash**, um interpretador de comandos, também chamado de *shell*. Depois da primeira linha, os comandos serão executados **dentro do container**:

   ```console
   $ docker run -it --name explorador python:3.12-slim bash
   $ cat /etc/os-release
   $ ls /
   $ hostname
   $ python --version
   ```

3. Ainda dentro do container, crie um arquivo e saia. O símbolo `>` grava o texto produzido por `echo` no arquivo indicado:

   ```console
   $ echo "eu estive aqui" > /marca.txt
   $ exit
   ```

4. De volta ao Codespace, tente ler o arquivo em **outro** container. O erro *No such file or directory* é esperado: o arquivo existe apenas no `explorador`.

   ```console
   $ docker run --rm python:3.12-slim cat /marca.txt
   ```
:::

::::columns
:::card Verificação
```console
$ check.sh 02
```

Execute no terminal do Codespace. A verificação procura o arquivo no `explorador` e avisa se faltou remover o container do Python interativo.
:::
:::card Missão extra
```console
$ docker start -ai explorador
$ cat /marca.txt
$ exit
```

O arquivo continua lá. Parar o container preserva sua camada de arquivos; removê-lo com `docker rm` apaga essa camada.
:::
::::
