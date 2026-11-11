---
duration: 8
---

# Antes de começar

<p class="eyebrow">Introdução</p>

## Como acompanhar a aula

{.lead}
Você não precisa saber programar. Os programas do curso já vêm prontos. Com eles, você aprende Docker um passo de cada vez.

::::columns
:::card Seu ambiente no navegador
O **Codespace** é um computador Linux acessado pela internet. Nele, o **VS Code** é o editor de arquivos, e o **terminal** é a área onde você digita comandos.

Abra o terminal em **Terminal → New Terminal**. A preparação completa está no [README do curso](https://github.com/fsilva-alt/devops-docker#antes-da-aula).
:::
:::card Comando ou conteúdo de arquivo?
Nos slides, o `$` marca uma linha de comando. Copie a linha sem esse símbolo, cole no terminal e pressione **Enter**. Rode uma linha por vez.

Quando a tarefa pedir um arquivo, cole o conteúdo no editor e salve com **Ctrl+S** (**Cmd+S** no Mac). Linhas que começam com `#` são comentários.
:::
:::card Como fazer os exercícios
Leia o objetivo, entre na pasta indicada e siga a tarefa. Ao terminar, rode `check.sh` com o número do exercício. Ele diz se está certo ou mostra o que falta ajustar.

A **Missão extra** é opcional. Copie os comandos da tarefa, que estão completos. Nas tabelas de consulta, `<nome>` é um valor que você troca, `[opção]` é uma parte opcional e `…` marca um exemplo abreviado.
:::
::::

:::card Instale o material do curso
No terminal do Codespace, rode o instalador e espere a mensagem **Curso de Docker instalado com sucesso!**:

```console
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/fsilva-alt/devops-docker/main/install.sh)"
```

Ele salva o curso em `~/devops-docker`, baixa as imagens da aula e prepara os exercícios em `~/labs`. Depois, abra um terminal novo para usar `check.sh`. Se já fez isso antes da aula, pode pular este passo.
:::

:::note Comandos para se localizar:
`pwd` mostra em que pasta você está, `ls` lista o que há nela e `cd caminho` entra em outra pasta. O `~` é a sua pasta pessoal. Para abrir um arquivo no editor, use `code nome-do-arquivo`.
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
: é um serviço que guarda e distribui imagens, como o Docker Hub
:::

:::note Uma imagem, vários containers.
A mesma imagem serve para criar quantos containers você quiser, em qualquer máquina compatível. Como ela leva junto o programa e as dependências nas versões certas, o programa roda igual na máquina de quem desenvolve e na de quem usa.
:::

<p class="eyebrow">Introdução</p>

## De onde veio o Docker?

<div class="gwrap" style="margin-bottom:22px"><svg class="tl" role="img" aria-label="Linha do tempo: 1979 chroot; 2006-2008 cgroups e namespaces no kernel Linux; 2008 LXC; 2013 nasce o Docker; 2015 OCI; hoje Compose e Kubernetes" viewBox="0 0 1000 150" width="1000"><line x1="40" y1="80" x2="960" y2="80"/><g><circle cx="100" cy="80" r="14"/><text x="100" y="85">79</text></g><text class="cap" x="100" y="118">chroot</text><text class="cap" x="100" y="134">um processo "preso" numa pasta</text><g><circle cx="300" cy="80" r="14"/><text x="300" y="85">06</text></g><text class="cap" x="300" y="118">cgroups + namespaces</text><text class="cap" x="300" y="134">isolamento e limites de recursos</text><g><circle cx="450" cy="80" r="14"/><text x="450" y="85">08</text></g><text class="cap" x="450" y="118">LXC</text><text class="cap" x="450" y="134">ferramentas para containers Linux</text><g class="hi"><circle cx="620" cy="80" r="18"/><text x="620" y="85" style="font-size:12px">13</text></g><text class="title" x="620" y="40">março de 2013 · nasce o Docker</text><text class="cap" x="620" y="120">Solomon Hykes mostra o Docker</text><text class="cap" x="620" y="136">numa palestra de 5 min na PyCon</text><g><circle cx="790" cy="80" r="14"/><text x="790" y="85">15</text></g><text class="cap" x="790" y="118">OCI</text><text class="cap" x="790" y="134">o formato vira padrão aberto</text><g class="end"><circle cx="930" cy="80" r="14"/><text x="930" y="85" style="font-size:10px">hoje</text></g><text class="cap" x="930" y="118">Compose · Kubernetes</text><text class="cap" x="930" y="134">gerenciamento de containers</text></svg></div>

::::columns
:::card O Linux já oferecia isolamento
<p class="up">antes de 2013</p>

O **kernel**, núcleo do Linux, já tinha recursos para isolar programas em execução e limitar quanta memória e quanto processador cada um usa. São os *namespaces* e *cgroups* da linha do tempo.
:::
:::card O Docker facilita o uso
<p class="up">março de 2013</p>

A dotCloud, uma empresa de hospedagem, publica o código do Docker. A ferramenta junta num só lugar a construção de imagens, a distribuição delas e comandos simples para rodar containers, como `docker run`.
:::
:::card Formatos compartilhados
<p class="up">2015 em diante</p>

A **OCI** (Open Container Initiative) define padrões abertos para as imagens e para a execução de containers. Com esses padrões, a mesma imagem funciona em ferramentas diferentes.
:::
::::

:::note
**Sobre os nomes da linha do tempo:** você não precisa decorar nenhum deles para fazer os exercícios. O Docker aproveitou o que o Linux já tinha e deixou mais fácil construir, compartilhar e rodar containers.
:::

:::note E a máquina virtual?
Uma máquina virtual roda um sistema operacional inteiro só para ela. O container usa o kernel da máquina em que está, por isso costuma iniciar mais rápido e gastar menos recursos.
:::

<p class="eyebrow">Introdução</p>

## Para que vamos usar o Docker?

::::columns
:::card Reutilizar um ambiente preparado
A imagem guarda o programa, as bibliotecas que ele usa e a versão do Python. A mesma imagem serve para desenvolver, testar e entregar o programa a outras pessoas.
:::
:::card Instalar dependências na imagem
O FastAPI é instalado uma vez, durante a construção da imagem, chamada de **build**. Todo container criado a partir dela já vem com esse pacote.
:::
:::card Criar e remover ambientes de teste
Dá para criar um container só para experimentar um programa e removê-lo ao terminar, sem instalar nada no Codespace.
:::
:::card Separar projetos
Dois projetos podem usar versões diferentes do Python, cada um no seu container. Os arquivos e as dependências de um não interferem nos do outro.
:::
::::

{.lead}
O exemplo do curso é um livro de receitas: primeiro no terminal, depois como uma API que entrega os dados e, no final, como um site no navegador.

<p class="eyebrow">Introdução</p>

## O que ainda precisa de cuidado?

::::columns
:::card Compatibilidade do sistema
Os containers desta aula usam o kernel Linux do Codespace. A imagem precisa ser compatível com o sistema e o processador da máquina onde vai rodar, porque um container não simula um computador completo.
:::
:::card Armazenamento dos dados
Quando um container é removido, os arquivos que só existiam nele são apagados. No exercício 13, os dados ficam em **volumes**, fora do container. Um volume não substitui um backup.
:::
:::card Várias máquinas
Nesta aula, os containers rodam em um único Codespace. Para distribuí-los entre várias máquinas, existem outras ferramentas, como o Kubernetes. Esse trabalho é chamado de **orquestração**.
:::
:::card Funcionamento do programa
A imagem leva tudo de que o programa precisa para rodar, mas não corrige erros no código. Você ainda precisa testar se o programa faz o que deveria.
:::
:::card Arquivos incluídos na imagem
Arquivos desnecessários deixam a imagem maior e mais demorada para baixar. No exercício 7, você escolhe o que fica de fora com o `.dockerignore`.
:::
:::card Senhas e outras informações privadas
Quem tem acesso à imagem consegue ler os arquivos que estão nela. Por isso, senhas são passadas na hora de rodar o container, nunca na construção da imagem. O exercício 9 mostra como passar configurações ao container.
:::
::::

<p class="eyebrow">Introdução</p>

## Docker, Docker Hub e Docker Desktop

<div class="flow"><div class="node hi"><b>Docker Engine</b><small>constrói imagens e executa containers no Codespace</small></div><div class="arr"><span class="a">⇄</span>baixar / publicar imagens</div><div class="node"><b>Docker Hub</b><small>serviço de armazenamento e distribuição de imagens</small></div></div>

`Docker Engine`
: É o Docker instalado no Codespace. Depois de baixar uma imagem, ele cria containers com ela sem precisar baixar de novo.

`Docker Hub`
: É de onde vêm as imagens `python`, `nginx` e `alpine` usadas no curso. Você não precisa ter conta no Docker Hub para esta aula.

`Docker Desktop`
: É um aplicativo para usar o Docker no seu computador. Você não precisa instalar, porque a aula usa o Docker que já vem no Codespace.

:::note
**Para acompanhar:** você precisa de uma conta no GitHub e do Codespace preparado como explica o README. Todos os comandos da aula rodam no terminal do Codespace.
:::

:::note
**Para abrir o site:** a aba **PORTS** (portas), ao lado de TERMINAL no VS Code, mostra o endereço para abrir no navegador. Ela é usada a partir do exercício 8.
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
