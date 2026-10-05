---
duration: 8
---

# Antes de começar

<p class="eyebrow">Introdução</p>

## Como acompanhar a aula

{.lead}
Você não precisa saber programar. Os programas do curso já estão prontos; vamos usá-los para aprender Docker, um passo de cada vez.

::::columns
:::card Seu ambiente no navegador
O **Codespace** é um computador Linux acessado pela internet. Nele, o **VS Code** é o editor de arquivos, e o **terminal** é a área onde você digita comandos.

Abra o terminal em **Terminal → New Terminal**. A preparação completa está no [README do curso](https://github.com/fsilva-alt/devops-docker#antes-da-aula).
:::
:::card Comando ou conteúdo de arquivo?
Nos slides, `$` marca uma linha para executar no terminal. Copie o comando sem esse símbolo e pressione **Enter**. Execute uma linha por vez.

Quando a instrução pedir um arquivo, copie o conteúdo no editor e salve com **Ctrl+S** ou **Cmd+S** no Mac. Linhas com `#` são comentários.
:::
:::card Como fazer os desafios
Leia o objetivo, entre na pasta indicada e siga a tarefa. Ao terminar, execute `check.sh` com o número do desafio: ele confirma o resultado ou mostra o que ajustar.

A **Missão extra** é opcional. Para executar os comandos, use os exemplos completos da tarefa. Nas tabelas de consulta, `<nome>` indica um valor a substituir, `[opção]` indica algo opcional, e `…` indica um exemplo abreviado.
:::
::::

:::note Comandos para se localizar:
`pwd` mostra a pasta atual; `ls` lista seu conteúdo; `cd caminho` entra em outra pasta. O símbolo `~` representa sua pasta pessoal. Para abrir um arquivo no editor, use `code nome-do-arquivo`.
:::

<p class="eyebrow">Introdução</p>

## O que é um container?

{.lead}
Um **container** é um ambiente isolado para executar um programa. Ele tem seus próprios arquivos e configurações, mas compartilha o núcleo do sistema operacional com a máquina em que está rodando.

:::card Por que isso ajuda?
Um programa pode precisar de uma versão específica do Python e de outros pacotes de software, chamados **dependências**. Se faltar um deles, aparece um erro como este:

```console
$ python app.py
ModuleNotFoundError: No module named 'fastapi'
```

A mensagem diz que o pacote fastapi não foi encontrado.
:::

:::card Imagem e container
`imagem`
: reúne o programa, suas dependências e os arquivos necessários. Serve de base para criar containers

`container`
: é criado a partir de uma imagem para executar o programa. Cada container tem seu próprio estado e pode ser iniciado, parado ou removido

`registro`
: é um serviço que armazena e distribui imagens, como o Docker Hub
:::

:::note Uma imagem, vários containers.
Você pode usar a mesma imagem em ambientes compatíveis, levando junto as versões do programa e de suas dependências. Isso reduz diferenças entre o ambiente de quem desenvolve e o de quem executa.
:::

<p class="eyebrow">Introdução</p>

## De onde veio o Docker?

<div class="gwrap" style="margin-bottom:22px"><svg class="tl" role="img" aria-label="Linha do tempo: 1979 chroot; 2006-2008 cgroups e namespaces no kernel Linux; 2008 LXC; 2013 nasce o Docker; 2015 OCI; hoje Compose e Kubernetes" viewBox="0 0 1000 150" width="1000"><line x1="40" y1="80" x2="960" y2="80"/><g><circle cx="100" cy="80" r="14"/><text x="100" y="85">79</text></g><text class="cap" x="100" y="118">chroot</text><text class="cap" x="100" y="134">um processo "preso" numa pasta</text><g><circle cx="300" cy="80" r="14"/><text x="300" y="85">06</text></g><text class="cap" x="300" y="118">cgroups + namespaces</text><text class="cap" x="300" y="134">isolamento e limites de recursos</text><g><circle cx="450" cy="80" r="14"/><text x="450" y="85">08</text></g><text class="cap" x="450" y="118">LXC</text><text class="cap" x="450" y="134">ferramentas para containers Linux</text><g class="hi"><circle cx="620" cy="80" r="18"/><text x="620" y="85" style="font-size:12px">13</text></g><text class="title" x="620" y="40">março de 2013 · nasce o Docker</text><text class="cap" x="620" y="120">Solomon Hykes mostra o Docker</text><text class="cap" x="620" y="136">numa palestra de 5 min na PyCon</text><g><circle cx="790" cy="80" r="14"/><text x="790" y="85">15</text></g><text class="cap" x="790" y="118">OCI</text><text class="cap" x="790" y="134">o formato vira padrão aberto</text><g class="end"><circle cx="930" cy="80" r="14"/><text x="930" y="85" style="font-size:10px">hoje</text></g><text class="cap" x="930" y="118">Compose · Kubernetes</text><text class="cap" x="930" y="134">gerenciamento de containers</text></svg></div>

::::columns
:::card O Linux já oferecia isolamento
<p class="up">antes de 2013</p>

O **kernel**, núcleo do Linux, já tinha recursos para separar programas em execução e limitar seu uso de memória e processador. São os *namespaces* e *cgroups* da linha do tempo.
:::
:::card O Docker facilita o uso
<p class="up">março de 2013</p>

A empresa de hospedagem dotCloud publica o código do Docker. A ferramenta reúne a construção e a distribuição de imagens com comandos como `docker run` para executar containers.
:::
:::card Formatos compartilhados
<p class="up">2015 em diante</p>

A **OCI** (Open Container Initiative) define padrões abertos para imagens e execução de containers. Esses padrões permitem usar imagens com diferentes ferramentas compatíveis.
:::
::::

:::note
**Sobre os nomes da linha do tempo:** você não precisa memorizá-los para fazer os exercícios. O ponto principal é que o Docker tornou mais fácil construir, compartilhar e executar ambientes com containers.
:::

:::note E a máquina virtual?
Ela executa um sistema operacional próprio. Um container compartilha o kernel da máquina que o executa; por isso, normalmente exige menos recursos para iniciar.
:::

<p class="eyebrow">Introdução</p>

## Para que vamos usar o Docker?

::::columns
:::card Reutilizar um ambiente preparado
A imagem guarda o programa, as bibliotecas que ele usa e a versão do Python. Podemos usar essa mesma imagem ao desenvolver, testar e disponibilizar o programa para outras pessoas.
:::
:::card Instalar dependências na imagem
Vamos instalar o FastAPI durante a construção da imagem, chamada de **build**. Depois, cada container criado a partir dela já terá esse pacote disponível.
:::
:::card Criar e remover ambientes de teste
Podemos criar um container para experimentar um programa e removê-lo ao terminar. Não é preciso instalar esse programa diretamente no sistema do Codespace.
:::
:::card Separar projetos
Dois projetos podem usar versões diferentes do Python, cada um em seu container. Os arquivos e as dependências de um não substituem os do outro.
:::
::::

{.lead}
Na prática, usaremos um livro de receitas: primeiro no terminal, depois como uma API que fornece dados e, por fim, como um site no navegador.

<p class="eyebrow">Introdução</p>

## O que ainda precisa de cuidado?

::::columns
:::card Compatibilidade do sistema
Os containers desta aula usam o kernel Linux do Codespace. A imagem precisa ser compatível com o sistema e a arquitetura que vão executá-la; ela não simula um computador completo.
:::
:::card Armazenamento dos dados
Remover um container apaga os arquivos guardados apenas na camada própria dele. No desafio 11, usaremos **volumes** para manter dados fora dessa camada. Um volume não substitui uma cópia de segurança.
:::
:::card Várias máquinas
Nesta aula, os containers rodam em um único Codespace. Distribuí-los entre várias máquinas exige outras ferramentas, como Kubernetes. Esse gerenciamento é chamado de **orquestração**.
:::
:::card Funcionamento do programa
A imagem reúne o que o programa precisa para executar, mas não corrige erros no código. Ainda é necessário testar se o programa produz o resultado esperado.
:::
:::card Arquivos incluídos na imagem
Arquivos desnecessários aumentam o tamanho da imagem e o tempo de transferência. No desafio 7, vamos escolher o que fica de fora usando `.dockerignore`.
:::
:::card Senhas e outras informações privadas
Quem tem acesso à imagem pode ler os arquivos que ela contém. Senhas devem ser fornecidas na execução, nunca durante a construção da imagem. Veremos configurações de execução no desafio 9.
:::
::::

<p class="eyebrow">Introdução</p>

## Docker, Docker Hub e Docker Desktop

<div class="flow"><div class="node hi"><b>Docker Engine</b><small>constrói imagens e executa containers no Codespace</small></div><div class="arr"><span class="a">⇄</span>baixar / publicar imagens</div><div class="node"><b>Docker Hub</b><small>serviço de armazenamento e distribuição de imagens</small></div></div>

`Docker Engine`
: É o Docker instalado no Codespace. Depois de obter uma imagem, ele pode criar containers com ela sem baixá-la novamente.

`Docker Hub`
: É de onde vêm as imagens `python`, `nginx` e `alpine` usadas no curso. Nesta aula, você não precisa criar uma conta no Docker Hub.

`Docker Desktop`
: É um aplicativo para usar Docker no computador pessoal. Não precisamos instalá-lo, pois usaremos o Docker que já está no Codespace.

:::note
**Para acompanhar:** tenha sua conta no GitHub e o Codespace preparado conforme o README. Os comandos da aula serão executados no terminal desse ambiente.
:::

:::note
**Para abrir o site:** a aba **PORTS** (portas), ao lado de TERMINAL no VS Code, fornece o endereço de acesso pelo navegador. Vamos usá-la a partir do desafio 8.
:::

:::card Para ler depois
Links para consultar depois. A documentação do Docker está em inglês.

{.links}
- [Visão geral do Docker](https://docs.docker.com/get-started/docker-overview/)<small>documentação oficial · em inglês</small>
- [O que é um container?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-container/)<small>documentação oficial · em inglês</small>
- [O que é uma imagem?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-an-image/)<small>documentação oficial · em inglês</small>
- [Onde as imagens são publicadas?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-registry/)<small>Docker Hub e outros registros · em inglês</small>
- [Descomplicando Docker (livro gratuito)](https://livro.descomplicandodocker.com.br/)<small>pt-br</small>
:::
