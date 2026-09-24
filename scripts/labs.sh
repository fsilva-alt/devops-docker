#!/usr/bin/env bash
# Geradores dos laboratórios. Carregado por setup.sh e reset.sh.
#
# Cada função gerar_NN cria a pasta do desafio já no estado inicial descrito em
# exercises/NN-nome/README.md. Cada limpar_NN remove o que o desafio criou no
# Docker (containers, imagens, volumes, redes), para o reset.sh recomeçar do zero.

# ---------------------------------------------------------------------------
# Conteúdo do "projeto" que os alunos colocam em containers: um livro de
# receitas, primeiro como script, depois como API em FastAPI e como site.
# ---------------------------------------------------------------------------

receitas_py() {
cat <<'EOF'
"""Livro de receitas: lista as receitas disponíveis."""

RECEITAS = [
    ("Bolo de cenoura", "8 porções"),
    ("Brigadeiro", "30 unidades"),
    ("Pão de queijo", "25 unidades"),
]

print("Livro de receitas")
print("=================")
for nome, rende in RECEITAS:
    print(f"- {nome} (rende {rende})")
EOF
}

# app_py [env] [reload]
#   env    -> lê a variável de ambiente COZINHA (desafios 9 em diante)
#   reload -> uvicorn com reload=True, que reinicia quando o arquivo muda (desafio 10)
app_py() {
  local env=0 reload=0 a
  for a in "$@"; do
    [[ "$a" == env ]] && env=1
    [[ "$a" == reload ]] && reload=1
  done
  printf '"""Livro de receitas: uma API mínima em FastAPI."""\n\n'
  if (( env )); then printf 'import os\n\n'; fi
  printf 'import uvicorn\nfrom fastapi import FastAPI\n\napp = FastAPI(title="Livro de receitas")\n\n'
  if (( env )); then
    printf '# O nome da cozinha vem de fora, pela variável de ambiente COZINHA.\n'
    printf 'COZINHA = os.environ.get("COZINHA", "Cozinha sem nome")\n\n'
  fi
  cat <<'EOF'
RECEITAS = [
    {"nome": "Bolo de cenoura", "rende": "8 porções"},
    {"nome": "Brigadeiro", "rende": "30 unidades"},
    {"nome": "Pão de queijo", "rende": "25 unidades"},
]


@app.get("/")
def inicio():
EOF
  if (( env )); then
    printf '    return {"mensagem": f"Livro de receitas da {COZINHA}", "receitas": "/receitas"}\n'
  else
    printf '    return {"mensagem": "Livro de receitas", "receitas": "/receitas"}\n'
  fi
  cat <<'EOF'


@app.get("/receitas")
def receitas():
    return RECEITAS


if __name__ == "__main__":
EOF
  if (( reload )); then
    printf '    # reload=True: o uvicorn reinicia sozinho quando app.py muda.\n'
    printf '    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)\n'
  else
    printf '    # 0.0.0.0 = aceita conexões de fora do container (o 127.0.0.1 de lá é só de lá).\n'
    printf '    uvicorn.run(app, host="0.0.0.0", port=8000)\n'
  fi
}

requirements_txt() { printf 'fastapi==0.115.6\nuvicorn==0.34.0\n'; }

# dockerfile_api <ingenuo|bom> [expose] [env]
#   ingenuo -> COPY . . antes do pip install (desafio 6 corrige)
#   bom     -> requirements.txt primeiro, para o cache funcionar
dockerfile_api() {
  local ordem="$1"; shift
  local expose=0 env=0 a
  for a in "$@"; do
    [[ "$a" == expose ]] && expose=1
    [[ "$a" == env ]] && env=1
  done
  printf 'FROM python:3.12-slim\n\nWORKDIR /app\n\n'
  if [[ "$ordem" == ingenuo ]]; then
    printf 'COPY . .\nRUN pip install --no-cache-dir -r requirements.txt\n'
  else
    printf 'COPY requirements.txt .\nRUN pip install --no-cache-dir -r requirements.txt\n\nCOPY . .\n'
  fi
  if (( env )); then printf '\nENV COZINHA="Cozinha do Curso"\n'; fi
  if (( expose )); then printf '\nEXPOSE 8000\n'; fi
  printf '\nCMD ["python", "app.py"]\n'
}

bloco_py() {
cat <<'EOF'
"""Bloco de notas: guarda cada nota em /dados/notas.txt e mostra todas."""

import sys
from pathlib import Path

ARQUIVO = Path("/dados/notas.txt")

# Se veio uma nota na linha de comando, acrescenta ao arquivo.
if len(sys.argv) > 1:
    ARQUIVO.parent.mkdir(parents=True, exist_ok=True)
    with ARQUIVO.open("a", encoding="utf-8") as f:
        f.write(" ".join(sys.argv[1:]) + "\n")

if ARQUIVO.exists():
    print("Notas guardadas:")
    for i, linha in enumerate(ARQUIVO.read_text(encoding="utf-8").splitlines(), 1):
        print(f"{i}. {linha}")
else:
    print("Nenhuma nota ainda.")
EOF
}

dockerfile_bloco() {
cat <<'EOF'
FROM python:3.12-slim

COPY bloco.py /app/bloco.py

# ENTRYPOINT é o programa; o que vier depois de "docker run <imagem>" vira argumento dele.
ENTRYPOINT ["python", "/app/bloco.py"]
EOF
}

cliente_py() {
cat <<'EOF'
"""Cliente: busca as receitas na API chamando o container pelo nome."""

import json
import urllib.request

URL = "http://receitas:8000/receitas"

with urllib.request.urlopen(URL, timeout=5) as resposta:
    receitas = json.load(resposta)

print(f"A API em {URL} respondeu com {len(receitas)} receitas:")
for r in receitas:
    print(f"- {r['nome']} (rende {r['rende']})")
EOF
}

# --- site estático (HTML/JS) --------------------------------------------------

site_index_html() {
cat <<'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Livro de receitas</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <main>
    <h1>Livro de receitas</h1>
    <p id="origem">Carregando…</p>
    <ul id="receitas"></ul>
  </main>
  <script src="app.js"></script>
</body>
</html>
EOF
}

site_style_css() {
cat <<'EOF'
body { font-family: system-ui, sans-serif; background: #fff8f0; color: #333; margin: 0; }
main { max-width: 32rem; margin: 3rem auto; padding: 0 1rem; }
h1 { color: #c2410c; }
#origem { color: #777; font-size: 0.9rem; }
li { padding: 0.4rem 0; border-bottom: 1px solid #eee; }
EOF
}

# site_app_js <url>   (receitas.json no desafio 12; /api/receitas no 14)
site_app_js() {
cat <<EOF
// Busca a lista de receitas e desenha na página.
const URL_RECEITAS = "$1";

async function carregar() {
  const lista = document.getElementById("receitas");
  const origem = document.getElementById("origem");
  try {
    const resposta = await fetch(URL_RECEITAS);
    const receitas = await resposta.json();
    origem.textContent = \`\${receitas.length} receitas vindas de \${URL_RECEITAS}\`;
    lista.innerHTML = "";
    for (const r of receitas) {
      const item = document.createElement("li");
      item.textContent = \`\${r.nome} — rende \${r.rende}\`;
      lista.appendChild(item);
    }
  } catch (erro) {
    origem.textContent = \`Não consegui carregar \${URL_RECEITAS}: \${erro.message}\`;
  }
}

carregar();
EOF
}

site_receitas_json() {
cat <<'EOF'
[
  {"nome": "Bolo de cenoura", "rende": "8 porções"},
  {"nome": "Brigadeiro", "rende": "30 unidades"},
  {"nome": "Pão de queijo", "rende": "25 unidades"}
]
EOF
}

nginx_conf() {
cat <<'EOF'
server {
    listen 80;

    # Os arquivos do site
    location / {
        root  /usr/share/nginx/html;
        index index.html;
    }

    # Tudo o que começa com /api/ é repassado ao container "api", pelo nome.
    # O "resolver" é o DNS interno do Docker: assim o nginx procura o "api" de
    # novo a cada poucos segundos e continua achando se o container for recriado.
    location /api/ {
        resolver 127.0.0.11 valid=5s;
        set $api "http://api:8000";
        rewrite ^/api/(.*)$ /$1 break;
        proxy_pass $api;
    }
}
EOF
}

dockerfile_web() {
cat <<'EOF'
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY site/ /usr/share/nginx/html/
EOF
}

# gerar_site DIR URL  — os quatro arquivos do site em DIR
gerar_site() {
  mkdir -p "$1"
  site_index_html   > "$1/index.html"
  site_style_css    > "$1/style.css"
  site_app_js "$2"  > "$1/app.js"
  site_receitas_json > "$1/receitas.json"
}

# ---------------------------------------------------------------------------
# Desafios 1 a 3 — sem pasta: só containers
# ---------------------------------------------------------------------------
limpar_01() {
  local id
  for id in $(containers_de hello-world); do rm_container "$id"; done
  for id in $(containers_de python:3.12-slim); do
    [[ "$(container_cmd "$id")" == *print* ]] && rm_container "$id"
  done
  return 0
}

limpar_02() {
  local id
  rm_container explorador
  for id in $(containers_de python:3.12-slim); do
    [[ "$(container_cmd "$id")" == python3 ]] && rm_container "$id"
  done
  return 0
}

limpar_03() { rm_container relogio descartavel; }

# ---------------------------------------------------------------------------
# Desafio 4 — Meu primeiro Dockerfile
# ---------------------------------------------------------------------------
gerar_04() {
  local dir; dir="$(lab_dir 04)"
  mkdir -p "$dir"
  receitas_py > "$dir/receitas.py"
}
limpar_04() { rm_imagem receitas:1.0 receitas:latest; }

# ---------------------------------------------------------------------------
# Desafio 5 — Instalando dependências
# ---------------------------------------------------------------------------
gerar_05() {
  local dir; dir="$(lab_dir 05)"
  mkdir -p "$dir"
  app_py > "$dir/app.py"
  requirements_txt > "$dir/requirements.txt"
}
limpar_05() { rm_imagem receitas-api:1.0; }

# ---------------------------------------------------------------------------
# Desafio 6 — Camadas e cache
# ---------------------------------------------------------------------------
gerar_06() {
  local dir; dir="$(lab_dir 06)"
  mkdir -p "$dir"
  app_py > "$dir/app.py"
  requirements_txt > "$dir/requirements.txt"
  dockerfile_api ingenuo > "$dir/Dockerfile"
}
limpar_06() { rm_imagem receitas-api:1.1; }

# ---------------------------------------------------------------------------
# Desafio 7 — O que não entra na imagem
# ---------------------------------------------------------------------------
gerar_07() {
  local dir; dir="$(lab_dir 07)"
  mkdir -p "$dir"
  app_py > "$dir/app.py"
  requirements_txt > "$dir/requirements.txt"
  dockerfile_api bom > "$dir/Dockerfile"
  # Lixo que costuma existir na pasta de um projeto e não deve ir para a imagem:
  # um ambiente virtual do Python (grande e inútil dentro do container)...
  mkdir -p "$dir/.venv/bin" "$dir/.venv/lib/python3.12/site-packages/fastapi"
  printf '#!/bin/sh\necho "python de mentira"\n' > "$dir/.venv/bin/python"
  head -c 3000000 /dev/zero > "$dir/.venv/lib/python3.12/site-packages/fastapi/__init__.py"
  # ...cache do Python...
  mkdir -p "$dir/__pycache__"
  head -c 2000 /dev/zero > "$dir/__pycache__/app.cpython-312.pyc"
  # ...um segredo e anotações pessoais...
  printf 'SENHA_DO_BANCO=batata123\n' > "$dir/.env"
  printf 'Lembrar de comprar cenouras.\nSenha do wifi: batata123\n' > "$dir/notas-pessoais.md"
  # ...e fotos, que nada têm a ver com a API.
  mkdir -p "$dir/fotos"
  head -c 2000000 /dev/zero > "$dir/fotos/bolo-de-cenoura.jpg"
}
limpar_07() { rm_imagem receitas-api:1.2; }

# ---------------------------------------------------------------------------
# Desafio 8 — Abrindo portas
# ---------------------------------------------------------------------------
gerar_08() {
  local dir; dir="$(lab_dir 08)"
  mkdir -p "$dir"
  app_py > "$dir/app.py"
  requirements_txt > "$dir/requirements.txt"
  dockerfile_api bom > "$dir/Dockerfile"       # sem EXPOSE: o aluno acrescenta
  printf '__pycache__/\n.venv/\n.env\n' > "$dir/.dockerignore"
}
limpar_08() { rm_container api; rm_imagem receitas-api:1.3; }

# ---------------------------------------------------------------------------
# Desafio 9 — Configuração por ambiente
# ---------------------------------------------------------------------------
gerar_09() {
  local dir; dir="$(lab_dir 09)"
  mkdir -p "$dir"
  app_py env > "$dir/app.py"
  requirements_txt > "$dir/requirements.txt"
  dockerfile_api bom expose > "$dir/Dockerfile"   # sem ENV: o aluno acrescenta
  printf '__pycache__/\n.venv/\n.env\n' > "$dir/.dockerignore"
  printf '# Um valor por linha, sem aspas nem espaços em volta do =\nCOZINHA=Cozinha da Vovó\n' > "$dir/cozinha.env"
}
limpar_09() { rm_container cozinha; rm_imagem receitas-api:1.4; }

# ---------------------------------------------------------------------------
# Desafio 10 — Editando ao vivo
# ---------------------------------------------------------------------------
gerar_10() {
  local dir; dir="$(lab_dir 10)"
  mkdir -p "$dir"
  app_py env reload > "$dir/app.py"
  requirements_txt > "$dir/requirements.txt"
  dockerfile_api bom expose env > "$dir/Dockerfile"
  printf '__pycache__/\n.venv/\n.env\n' > "$dir/.dockerignore"
}
limpar_10() { rm_container dev; rm_imagem receitas-api:1.5; }

# ---------------------------------------------------------------------------
# Desafio 11 — Dados que ficam
# ---------------------------------------------------------------------------
gerar_11() {
  local dir; dir="$(lab_dir 11)"
  mkdir -p "$dir"
  bloco_py > "$dir/bloco.py"
  dockerfile_bloco > "$dir/Dockerfile"
}
limpar_11() { rm_imagem bloco:1.0; rm_volume notas; }

# ---------------------------------------------------------------------------
# Desafio 12 — Site estático
# ---------------------------------------------------------------------------
gerar_12() {
  local dir; dir="$(lab_dir 12)"
  gerar_site "$dir/site" receitas.json
}
limpar_12() { rm_container web; rm_imagem receitas-web:1.0; }

# ---------------------------------------------------------------------------
# Desafio 13 — Containers conversando
# ---------------------------------------------------------------------------
gerar_13() {
  local dir; dir="$(lab_dir 13)"
  mkdir -p "$dir"
  app_py env > "$dir/app.py"
  requirements_txt > "$dir/requirements.txt"
  dockerfile_api bom expose env > "$dir/Dockerfile"
  printf '__pycache__/\n.venv/\n.env\n' > "$dir/.dockerignore"
  cliente_py > "$dir/cliente.py"
}
limpar_13() { rm_container receitas; rm_rede cozinha; rm_imagem receitas-api:1.6; }

# ---------------------------------------------------------------------------
# Desafio 14 — Docker Compose
# ---------------------------------------------------------------------------
gerar_14() {
  local dir; dir="$(lab_dir 14)"
  mkdir -p "$dir/api" "$dir/web"
  app_py env > "$dir/api/app.py"
  requirements_txt > "$dir/api/requirements.txt"
  dockerfile_api bom expose env > "$dir/api/Dockerfile"
  printf '__pycache__/\n.venv/\n.env\n' > "$dir/api/.dockerignore"
  dockerfile_web > "$dir/web/Dockerfile"
  nginx_conf > "$dir/web/nginx.conf"
  gerar_site "$dir/web/site" /api/receitas
}
limpar_14() {
  local dir f; dir="$(lab_dir 14)"
  for f in compose.yaml compose.yml docker-compose.yaml docker-compose.yml; do
    if [[ -f "$dir/$f" ]]; then
      ( cd "$dir" && docker compose down --rmi local -v --remove-orphans >/dev/null 2>&1 ) || true
      break
    fi
  done
  # Se o compose.yaml sumiu, os containers ainda podem existir com o nome do projeto
  local id
  for id in $(docker ps -aq --filter "label=com.docker.compose.project=$(basename "$dir")" 2>/dev/null || true); do
    rm_container "$id"
  done
  rm_rede "$(basename "$dir")_default"
  rm_imagem "$(basename "$dir")-api" "$(basename "$dir")-web"
}

# ---------------------------------------------------------------------------
# gerar_lab NN — recria o desafio NN (apaga a pasta e o que ele criou no Docker)
# ---------------------------------------------------------------------------
gerar_lab() {
  local nn="$1"
  if declare -F "limpar_$nn" >/dev/null; then "limpar_$nn"; fi
  if lab_tem_pasta "$nn"; then
    local dir; dir="$(lab_dir "$nn")"
    mkdir -p "$LABS_DIR"
    cd "$LABS_DIR"    # o diretório atual pode ser justamente o que vai ser apagado
    rm -rf "$dir"
    "gerar_$nn"
  fi
}
