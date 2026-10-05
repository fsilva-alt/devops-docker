# Exercício 6 — Camadas e cache

⏱ 5 minutos · Módulo 2: Dockerfile · **Opcional**

Pode ser feito depois da aula. O exercício 8 não depende deste, porque já traz um Dockerfile com a ordem ajustada.

## Objetivo

Organizar o `Dockerfile` para que uma alteração no código não obrigue o Docker a reinstalar as dependências, e observar como ele reaproveita resultados de etapas anteriores para construir a imagem mais rápido.

## Onde

```bash
cd ~/labs/06-camadas-e-cache
```

## Estado inicial

`app.py`, `requirements.txt` e um `Dockerfile` igual ao do exercício 5, com `COPY . .` **antes** do `pip install`.

## Como o cache funciona

A imagem é formada por **camadas**, que guardam alterações nos arquivos. Durante a construção, o Docker pode reaproveitar o resultado de uma etapa quando a instrução, sua base e os arquivos usados continuam iguais. Esse reaproveitamento é chamado de **cache** e aparece na saída como `CACHED`.

Quando uma etapa muda, as etapas seguintes que dependem dela também precisam ser refeitas. Algumas instruções, como `CMD`, guardam configurações, em vez de acrescentar arquivos.

Com `COPY . .` antes do `pip install`, qualquer edição em `app.py` muda a camada do `COPY`, e o `pip install` roda de novo, embora `requirements.txt` não tenha mudado.

## Tarefa

1. Construa a imagem uma primeira vez:

   ```bash
   docker build -t receitas-api:1.1 .
   ```

2. Abra `app.py` com `code app.py`. Procure a lista que começa com `RECEITAS = [` e acrescente esta linha antes do `]` que fecha a lista, mantendo o alinhamento das receitas anteriores:

   ```python
   {"nome": "Mousse de maracujá", "rende": "6 porções"},
   ```

   Copie a linha inteira, com as aspas, as chaves e a vírgula final, como nas outras receitas. Salve e construa de novo. Repare que o `pip install` roda outra vez, mesmo sem nenhuma mudança na lista de dependências:

   ```bash
   docker build -t receitas-api:1.1 .
   ```

3. Abra o `Dockerfile` e substitua o conteúdo pelo exemplo abaixo. Ele copia primeiro `requirements.txt`, instala as dependências e só depois copia o restante do projeto. Salve o arquivo:

   ```dockerfile
   FROM python:3.12-slim

   WORKDIR /app

   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt

   COPY . .

   CMD ["python", "app.py"]
   ```

4. Construa a imagem com a nova ordem. Nessa primeira construção, o pip pode rodar de novo ou aproveitar o cache preparado pelo instalador. Depois, em `app.py`, troque `Mousse de maracujá` por `Mousse de limão`, salve e construa mais uma vez. Agora, a etapa do pip deve aparecer como `CACHED`:

   ```bash
   docker build -t receitas-api:1.1 .
   # edite app.py
   docker build -t receitas-api:1.1 .
   ```

5. Consulte o histórico de construção da imagem, com as instruções e o tamanho associado a cada etapa:

   ```bash
   docker history receitas-api:1.1
   ```

## Verificação

```bash
check.sh 06
```

A verificação passa quando o `Dockerfile` está na ordem certa, o `app.py` foi alterado e a imagem contém a versão atual dele.

## Dica

A regra geral é colocar primeiro o que muda menos (sistema, dependências) e por último o que muda mais (o seu código).

## Missão extra

Veja quanto tempo o cache economiza. `time` mede a duração de um comando; compare o valor de `real` na construção sem cache e na construção normal:

```bash
time docker build --no-cache -t receitas-api:1.1 .
time docker build -t receitas-api:1.1 .
```
