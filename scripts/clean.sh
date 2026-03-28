#!/usr/bin/env bash

## Script para limpar artefatos gerados no JLPTrial
## Execute com: devbox run clean [OPÇÕES]
##
## Remove caches, builds, dependências e bancos gerados.
## Não remove código-fonte.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo $ROOT_DIR
APP_DIR="${ROOT_DIR}/app"
WEB_DIR="${ROOT_DIR}/web"
SERVER_DIR="${ROOT_DIR}/server"
DATABASE_OUTPUT_DIR="${ROOT_DIR}/database/outputs"

ERRO_BG="\033[0;41m"
APP="\033[0;30;46m"
SERVIDOR="\033[0;30;43m"
BANCO="\033[0;30;47m"
WEB="\033[0;30;45m"
JLPTRIAL="\033[0;30;42m"
RESET="\033[0m"

OPT_APP=0
OPT_WEB=0
OPT_BACKEND=0
OPT_DATABASE=0
OPT_DEVBOX=0

log_info() {
    echo -e "${JLPTRIAL}[JLPTRIAL]${RESET} $1"
}

log_error() {
    echo -e "${ERRO_BG}[JLPTRIAL]${RESET} $1"
}

help() {
    echo "Uso: devbox run clean [OPÇÕES]"
    echo ""
    echo "Limpa artefatos de desenvolvimento do JLPTrial."
    echo ""
    echo "Opções:"
    echo "  --all      Limpa app, web, backend e banco (padrão quando sem argumentos)"
    echo "  --app      Limpa dependências e artefatos gerados do app"
    echo "  --web      Limpa dependências e build do web"
    echo "  --backend  Limpa caches Python e ambiente virtual (.venv)"
    echo "  --database       Limpa saídas geradas em database/outputs"
    echo "  --devbox   Remove cache local do devbox (.devbox)"
    echo "  --help     Exibe esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  devbox run clean"
    echo "  devbox run clean --backend --database"
    echo "  devbox run clean --all"
}

set_default_options() {
    OPT_APP=1
    OPT_WEB=1
    OPT_BACKEND=1
    OPT_DATABASE=1
}

if [[ $# -eq 0 ]]; then
    set_default_options
else
    for arg in "$@"; do
        case "${arg}" in
            --all)
                set_default_options
                ;;
            --app)
                OPT_APP=1
                ;;
            --web)
                OPT_WEB=1
                ;;
            --backend)
                OPT_BACKEND=1
                ;;
            --database)
                OPT_DATABASE=1
                ;;
            --devbox)
                OPT_DEVBOX=1
                ;;
            --help|-h)
                help
                exit 0
                ;;
            *)
                log_error "Opção inválida: ${arg}"
                help
                exit 1
                ;;
        esac
    done
fi

if [[ ${OPT_APP} -eq 1 ]]; then
    echo -e "${APP}[APP     ]${RESET} Limpando app"
    rm -rf "${APP_DIR}/node_modules"
    rm -rf "${APP_DIR}/.expo"
    rm -rf "${APP_DIR}/.expo-shared"
    rm -rf "${APP_DIR}/android/.gradle"
    rm -rf "${APP_DIR}/android/app/build"
fi

if [[ ${OPT_WEB} -eq 1 ]]; then
    echo -e "${WEB}[WEB     ]${RESET} Limpando web"
    rm -rf "${WEB_DIR}/node_modules"
    rm -rf "${WEB_DIR}/dist"
fi

if [[ ${OPT_BACKEND} -eq 1 ]]; then
    echo -e "${SERVIDOR}[SERVIDOR]${RESET} Limpando backend"
    find "${ROOT_DIR}" -type d -name '__pycache__' -prune -exec rm -rf {} +
    find "${ROOT_DIR}" -type d -name '.mypy_cache' -prune -exec rm -rf {} +
    find "${ROOT_DIR}" -type d -name '.pytest_cache' -prune -exec rm -rf {} +
    find "${ROOT_DIR}" -type d -name '.ruff_cache' -prune -exec rm -rf {} +
    rm -rf "${ROOT_DIR}/.venv"

    if [[ -d "${SERVER_DIR}/.venv" ]]; then
        rm -rf "${SERVER_DIR}/.venv"
    fi
fi

if [[ ${OPT_DATABASE} -eq 1 ]]; then
    echo -e "${BANCO}[BANCO   ]${RESET} Limpando saídas de banco"
    rm -rf "${DATABASE_OUTPUT_DIR}"
fi

if [[ ${OPT_DEVBOX} -eq 1 ]]; then
    echo -e "${JLPTRIAL}[JLPTRIAL]${RESET} Removendo .devbox"
    rm -rf "${ROOT_DIR}/.devbox"
fi

log_info "Limpeza concluída"
