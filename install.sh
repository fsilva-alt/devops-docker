#!/bin/sh
# Instalador do Curso de Docker.
#
# Num Codespace em branco (ou em qualquer Linux com git e Docker), rode:
#
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fsilva-alt/devops-docker/main/install.sh)"
#
# O que ele faz:
#   1. vai para a sua pasta home;
#   2. baixa o curso para ~/devops-docker (ou atualiza, se já existir);
#   3. confere o Docker, baixa as imagens-base e gera os laboratórios em ~/labs;
#   4. coloca os comandos check.sh, reset.sh e setup.sh no PATH (bash e zsh);
#   5. mostra os próximos passos.
#
# Pode ser rodado de novo sem medo: é idempotente.
#
# Variáveis opcionais: CURSO_REPO (URL ou caminho do repositório), CURSO_RAMO,
# CURSO_DIR (padrão ~/devops-docker) e LABS_DIR (padrão ~/labs).

set -eu

CURSO_REPO="${CURSO_REPO:-https://github.com/fsilva-alt/devops-docker.git}"
CURSO_RAMO="${CURSO_RAMO:-main}"
CURSO_DIR="${CURSO_DIR:-$HOME/devops-docker}"
LABS_DIR="${LABS_DIR:-$HOME/labs}"
export LABS_DIR

passo() { printf '\033[34m▶\033[0m %s\n' "$*"; }
falha() { printf '\n\033[31m❌ %s\033[0m\n' "$*" >&2; exit 1; }

command -v git    >/dev/null 2>&1 || falha "O git não está instalado. Num Codespace ele já vem; em outra máquina, instale-o primeiro."
command -v bash   >/dev/null 2>&1 || falha "O bash não está instalado; os scripts do curso precisam dele."
command -v docker >/dev/null 2>&1 || falha "O docker não está instalado. Num Codespace ele já vem; em outra máquina: https://docs.docker.com/get-docker/"
command -v curl   >/dev/null 2>&1 || falha "O curl não está instalado; as verificações do curso precisam dele."

cd "$HOME"

# --- 1. Baixar ou atualizar o curso -------------------------------------------
if [ -d "$CURSO_DIR/.git" ]; then
  passo "Atualizando o curso em $CURSO_DIR"
  git -C "$CURSO_DIR" pull -q --ff-only 2>/dev/null \
    || falha "Não consegui atualizar $CURSO_DIR. Se você mexeu nessa pasta, apague-a e rode o instalador de novo."
else
  passo "Baixando o curso para $CURSO_DIR"
  git clone -q --depth 1 -b "$CURSO_RAMO" "$CURSO_REPO" "$CURSO_DIR" 2>/dev/null \
    || falha "Não consegui clonar $CURSO_REPO. Verifique a conexão e o endereço."
fi

# --- 2. Docker, imagens e laboratórios ---------------------------------------------
passo "Conferindo o Docker, baixando imagens e preparando os laboratórios em $LABS_DIR"
bash "$CURSO_DIR/scripts/setup.sh" || falha "O setup.sh não terminou. Leia a mensagem acima, corrija e rode o instalador de novo."

# --- 3. Comandos no PATH ------------------------------------------------------------
BLOCO_INICIO='# >>> curso de docker >>>'
BLOCO_FIM='# <<< curso de docker <<<'
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  # .bashrc é criado se não existir; .zshrc só é alterado se já existir
  if [ ! -f "$rc" ] && [ "$rc" != "$HOME/.bashrc" ]; then continue; fi
  if ! grep -qF "$BLOCO_INICIO" "$rc" 2>/dev/null; then
    {
      printf '\n%s\n' "$BLOCO_INICIO"
      printf 'export PATH="%s/scripts:$PATH"\n' "$CURSO_DIR"
      if [ "$LABS_DIR" != "$HOME/labs" ]; then printf 'export LABS_DIR="%s"\n' "$LABS_DIR"; fi
      printf '%s\n' "$BLOCO_FIM"
    } >> "$rc"
  fi
done

# --- 4. Mensagem final ----------------------------------------------------------------
n_labs=$(find "$LABS_DIR" -mindepth 1 -maxdepth 1 -type d -name '[0-9][0-9]-*' | wc -l | tr -d ' ')
printf '\n'
printf '\033[32m╭──────────────────────────────────────────────────────╮\033[0m\n'
printf '\033[32m│  ✅ Curso de Docker instalado com sucesso!           │\033[0m\n'
printf '\033[32m╰──────────────────────────────────────────────────────╯\033[0m\n'
printf '\n'
printf '  Curso (enunciados, docs):  %s\n' "$CURSO_DIR"
printf '  Laboratórios:              %s  (%s pastas prontas)\n' "$LABS_DIR" "$n_labs"
printf '\n'
printf '  Próximos passos:\n'
printf '  1. Abra um terminal novo, ou rode:   source ~/.bashrc\n'
printf '  2. Rode o seu primeiro container:    docker run hello-world\n'
printf '  3. Confira o ambiente:               check.sh 00\n'
printf '\n'
