---
duration: 6
---

# Meu primeiro Dockerfile

{.lead}
Criar a sua primeira **imagem**, com o programa de receitas que vem pronto no curso. Para isso, você escreve um `Dockerfile`, constrói a imagem com `docker build` e roda um container a partir dela.

`Dockerfile` `FROM` `COPY` `CMD` `docker build -t receitas:1.0 .` `docker run --rm receitas:1.0`

::::columns
:::card Onde fazer
```console
$ cd ~/labs/04-meu-primeiro-dockerfile
```

Rode este comando para entrar na pasta do exercício. O programa `receitas.py` já está pronto e mostra o livro de receitas no terminal. Para ler o código, use `cat receitas.py`.
:::
:::card Para este exercício
`⏱ tempo`
: 6 min

`parte`
: Dockerfile

`verificação`
: `check.sh 04`
:::
::::

<p class="eyebrow">Conceito</p>

## Dockerfile → imagem → container

<div class="flow"><div class="node"><b>Dockerfile + pasta do projeto</b><small>instruções e arquivos usados para construir a imagem</small></div><div class="arr"><span class="a">→</span><strong>docker build -t receitas:1.0 .</strong></div><div class="node hi"><b>imagem receitas:1.0</b><small>resultado da construção · aparece em docker images</small></div><div class="arr"><span class="a">→</span><strong>docker run --rm receitas:1.0</strong></div><div class="node"><b>container</b><small>executa o programa, mostra as receitas e é removido por --rm</small></div></div>

```dockerfile
FROM python:3.12-slim

COPY receitas.py /app/receitas.py

CMD ["python", "/app/receitas.py"]
```

| Instrução | O que faz |
| --- | --- |
| `FROM imagem` | começa a partir de uma imagem existente (aqui, a que já tem Python) |
| `COPY origem destino` | copia arquivos da pasta do projeto para a imagem |
| `CMD ["prog","arg"]` | define o comando padrão do container; aqui, o Python e o caminho do receitas.py |

<div class="layers"><div class="cap">a imagem receitas:1.0, de cima para baixo</div><div class="stk"><div class="layer dim"><b>CMD ["python", "/app/receitas.py"]</b><small>configuração do comando; não executa o programa no build</small></div><div class="layer hi"><b>COPY receitas.py /app/receitas.py</b><small>uma camada nova com o seu arquivo</small></div><div class="layer "><b>FROM python:3.12-slim</b><small>todas as camadas da imagem-base</small></div></div></div>

:::note
**Build** é a construção da imagem. O ponto `.` no final de `docker build` indica a pasta atual, chamada de **contexto de construção**. É nela que o Docker procura os arquivos usados pelo `COPY`. No exercício 7, você escolhe quais deles ficam de fora.
:::

<p class="eyebrow">Referência</p>

## Comandos e documentação

| Comando | Para quê |
| --- | --- |
| `docker build -t nome:tag .` | constrói a imagem a partir do Dockerfile da pasta atual |
| `docker images [nome]` | lista as imagens (filtrando pelo nome) |
| `docker tag origem destino` | dá outro nome à mesma imagem |
| `docker run --rm nome:tag` | roda o CMD da imagem e remove o container ao terminar |
| `docker image rm nome:tag` | remove a imagem (ou só a tag, se houver outras) |

:::card Documentação
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Como escrever um Dockerfile](https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/)<small>em inglês</small>
- [Dockerfile · FROM](https://docs.docker.com/reference/dockerfile/#from)
- [Dockerfile · COPY](https://docs.docker.com/reference/dockerfile/#copy)
- [Dockerfile · CMD](https://docs.docker.com/reference/dockerfile/#cmd)
- [Comando · docker build](https://docs.docker.com/reference/cli/docker/buildx/build/)<small>-t, --no-cache, -f</small>
- [Comando · docker tag](https://docs.docker.com/reference/cli/docker/image/tag/)
- [Comando · docker images](https://docs.docker.com/reference/cli/docker/image/ls/)
:::

<p class="eyebrow">Tarefa · 6 min</p>

## O exercício

:::steps
1. Rode `code Dockerfile` para abrir um arquivo novo no editor. Copie as três instruções do slide anterior e salve. O nome é exatamente `Dockerfile`, com D maiúsculo e sem `.txt` no final.

2. Volte ao terminal e construa a imagem. A opção `-t` define o nome `receitas` e a tag `1.0`, e o ponto indica a pasta atual:

   ```console
   $ docker build -t receitas:1.0 .
   ```

3. Confira se a imagem aparece na lista:

   ```console
   $ docker images receitas
   ```

4. Rode um container com a imagem. Não é preciso informar o comando Python, porque ele já está no `CMD`:

   ```console
   $ docker run --rm receitas:1.0
   ```
:::

:::card Verificação
```console
$ check.sh 04
```

A verificação roda a sua imagem e confere se o livro de receitas aparece.
:::

:::note
**Se precisar corrigir:** salve o Dockerfile e repita o `docker build`. O nome `receitas:1.0` passa a apontar para a imagem nova. Para rodar outro comando no lugar do `CMD`, escreva o comando depois da imagem, como em `docker run --rm receitas:1.0 python --version`.
:::

:::card Missão extra · tags
```console
$ docker tag receitas:1.0 receitas:latest
$ docker images receitas      # mesmo IMAGE ID, dois nomes
$ docker run --rm receitas    # sem tag = latest
```
:::
