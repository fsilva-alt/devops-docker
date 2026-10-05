# Exercício 11 — Dados que ficam

⏱ 5 minutos · Módulo 4: Dados · **Opcional**

Pode ficar para depois da aula. Os exercícios de site, redes e Compose não dependem deste volume, então você pode seguir direto para o 12.

## Objetivo

Primeiro, você vê o que acontece com os arquivos de um container quando ele é removido. Depois, usa um **volume**, um espaço de armazenamento gerenciado pelo Docker, para que as notas sobrevivam ao container que as criou.

## Onde

```bash
cd ~/labs/11-dados-que-ficam
```

## Estado inicial

- `bloco.py`: um bloco de notas. Cada nota passada na linha de comando é acrescentada a `/dados/notas.txt`; depois ele imprime todas.
- `Dockerfile`: pronto, com `ENTRYPOINT` no lugar de `CMD`. Neste exemplo, `ENTRYPOINT` define o programa a executar. O texto depois de `docker run bloco:1.0` é um **argumento**, uma informação passada ao programa; aqui, o argumento é o conteúdo da nota.

## Onde os dados ficam guardados

| Lugar | Até quando os dados ficam | Uso comum |
|---|---|---|
| Camada gravável do container | até o `docker rm` | arquivos temporários; cache |
| Bind mount (`-v /pasta/sua:/x`) | enquanto os arquivos existirem na pasta do Codespace | desenvolvimento (exercício 10); configuração |
| **Volume** (`-v nome:/x`) | até o `docker volume rm` | dados do programa: banco de dados, uploads, notas |

Um volume é, no fundo, uma pasta que o Docker administra. Para usá-lo, você só precisa do nome; não é preciso saber onde ele fica no disco.

## Tarefa

1. Construa e use o bloco duas vezes:

   ```bash
   docker build -t bloco:1.0 .
   docker run --rm bloco:1.0 "comprar cenouras"
   docker run --rm bloco:1.0 "assar o bolo"
   ```

   A segunda execução mostra apenas "assar o bolo". A primeira nota estava na camada gravável do primeiro container, que o `--rm` removeu ao final.

2. Crie um volume e ligue-o à pasta `/dados` do container:

   ```bash
   docker volume create notas
   docker run --rm -v notas:/dados bloco:1.0 "comprar cenouras"
   docker run --rm -v notas:/dados bloco:1.0 "assar o bolo"
   ```

   Agora as duas notas aparecem: os containers são diferentes, mas o volume é o mesmo.

3. Execute o programa sem passar uma nova nota. Ele apenas mostra as notas já guardadas. Depois, liste os volumes e consulte os detalhes de `notas`:

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
- O `--rm` continua removendo o container ao final. O volume nomeado `notas` permanece e pode ser usado por outros containers.

## Missão extra

O volume é independente da imagem. Leia o arquivo com outra imagem qualquer:

```bash
docker run --rm -v notas:/dados alpine cat /dados/notas.txt
```

Depois, experimente `docker volume rm notas` enquanto nenhum container o estiver usando. Esse comando apaga o volume **e as notas guardadas nele**. Confirme a remoção com `docker volume ls`. Para refazer o exercício, use `reset.sh 11`, entre novamente na pasta e repita as etapas; isso não recupera as notas apagadas.
