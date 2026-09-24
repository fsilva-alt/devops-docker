# Ambiente de teste: um Docker completo (daemon + cliente + compose) dentro de
# um container, com bash e as ferramentas que os scripts do curso usam. Nada do
# curso vem aqui: o instalador é quem monta tudo, como faria num Codespace.
FROM docker:28-dind

RUN apk add --no-cache bash curl coreutils git grep sed tar diffutils findutils

WORKDIR /root
