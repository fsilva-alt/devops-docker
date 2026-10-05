# Exercício 17 — Persistência com Compose

⏱ 6 minutos · Docker Compose · **Opcional, para depois da aula**

Faça depois do exercício 14 e antes da faxina. Não é preciso ter feito o 16.

## Objetivo

Você vai declarar um **volume nomeado no Compose**, gravar notas em containers temporários e conferir que elas permanecem após `docker compose down`.

## Onde

```bash
cd ~/labs/17-compose-persistencia
```

## Estado inicial

`bloco.py` e um `Dockerfile` prontos, como no exercício 11. Cada texto passado ao programa vira uma nota em `/dados/notas.txt`. Executar sem texto mostra as notas existentes.

## Tarefa

1. Execute `code compose.yaml`, copie o conteúdo e salve:

   ```yaml
   services:
     bloco:
       build: .
       image: receitas-notas:1.0
       volumes:
         - notas:/dados

   volumes:
     notas:
   ```

   O primeiro `volumes`, dentro de `bloco`, **monta** o volume no container. O segundo, alinhado com `services`, **declara** o volume do projeto. `notas` é um nome, não um caminho de pasta.

2. Valide, construa a imagem e grave duas notas:

   ```bash
   docker compose config
   docker compose build
   docker compose run --rm bloco "comprar cenouras"
   docker compose run --rm bloco "assar o bolo"
   ```

   `run` cria um container para uma execução do serviço. `--rm` remove esse container quando o programa termina, mas mantém o volume nomeado. O texto entre aspas chega ao `ENTRYPOINT` da imagem como argumento. A segunda execução deve mostrar as duas notas.

3. Remova os containers e a rede do projeto e consulte o volume:

   ```bash
   docker compose down
   docker volume ls
   docker volume inspect 17-compose-persistencia_notas
   ```

   O Compose usa o nome da pasta como prefixo do volume. O `down` remove containers e rede, mas, por padrão, **preserva os volumes nomeados**.

4. Crie outro container apenas para ler as notas:

   ```bash
   docker compose run --rm bloco
   ```

   As notas `comprar cenouras` e `assar o bolo` devem continuar lá.

## Verificação

```bash
check.sh 17
```

Confere a declaração do volume e se o serviço consegue ler as duas notas. Se quiser recomeçar do zero, use `reset.sh 17`, entre novamente na pasta e repita a tarefa.

## Missão extra

Depois de concluir a verificação, compare com a remoção explícita do volume:

```bash
docker compose down -v
docker compose run --rm bloco
```

`-v` remove também o volume e suas notas. A última execução cria um volume novo e mostra `Nenhuma nota ainda.`. A verificação deixará de aprovar até você gravar as duas notas novamente.
