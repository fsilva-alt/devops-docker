# Desafio 11 — Dados que ficam

⏱ 5 minutos · Módulo 4: Dados · desafio elástico

## Objetivo

Ver que tudo o que um container grava **morre com ele**, e guardar dados num **volume**, que sobrevive a quantos containers forem necessários.

## Onde

```bash
cd ~/labs/11-dados-que-ficam
```

## Estado inicial

- `bloco.py`: um bloco de notas. Cada nota passada na linha de comando é acrescentada a `/dados/notas.txt`; depois ele imprime todas.
- `Dockerfile`: pronto. Repare no `ENTRYPOINT` no lugar do `CMD`: o programa é fixo, e o que vier depois de `docker run bloco:1.0` vira **argumento** dele.

## Onde os dados moram

| Lugar | Vida | Para quê |
|---|---|---|
| Camada gravável do container | até o `docker rm` | arquivos temporários; cache |
| Bind mount (`-v /pasta/sua:/x`) | a pasta é sua | desenvolvimento (desafio 10); configuração |
| **Volume** (`-v nome:/x`) | até o `docker volume rm` | dados do programa: banco de dados, uploads, notas |

Um volume é uma pasta que o Docker guarda e administra. Você não precisa saber onde ela fica no disco; só o nome.

## Tarefa

1. Construa e use o bloco duas vezes:

   ```bash
   docker build -t bloco:1.0 .
   docker run --rm bloco:1.0 "comprar cenouras"
   docker run --rm bloco:1.0 "assar o bolo"
   ```

   A segunda execução mostra **só** "assar o bolo". A primeira nota morreu junto com o primeiro container.

2. Crie um volume e ligue-o à pasta `/dados` do container:

   ```bash
   docker volume create notas
   docker run --rm -v notas:/dados bloco:1.0 "comprar cenouras"
   docker run --rm -v notas:/dados bloco:1.0 "assar o bolo"
   ```

   Agora as duas notas aparecem: containers diferentes, mesmo volume.

3. Um container sem argumento só lê:

   ```bash
   docker run --rm -v notas:/dados bloco:1.0
   docker volume ls
   docker volume inspect notas
   ```

## Verificação

```bash
check.sh 11
```

## Dicas

- `-v notas:/dados` (nome) é volume; `-v "$PWD:/dados"` (caminho começando com `/`) é bind mount. A diferença é só o que vem antes do `:`.
- O `--rm` continua apagando o container. O volume não é do container; é do Docker.

## Missão extra

O volume é independente da imagem. Leia o arquivo com outra imagem qualquer:

```bash
docker run --rm -v notas:/dados alpine cat /dados/notas.txt
```

E veja o que acontece com `docker volume rm notas` enquanto nenhum container o usa (e por que `docker volume ls` já não o mostra). Recrie com `reset.sh 11` se quiser refazer.
