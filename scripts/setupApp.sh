#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="${ROOT_DIR}/app"

ERRO_BG="\033[0;41m"
APP="\033[0;30;46m"
RESET="\033[0m"

log_info() {
  echo -e "${APP}[APP     ]${RESET} $1"
}

log_error() {
  echo -e "${ERRO_BG}[APP     ]${RESET} $1"
}

if [[ ! -d "${APP_DIR}" ]]; then
  log_error "Pasta app não encontrada em ${APP_DIR}"
  exit 1
fi

cd "${APP_DIR}"

log_info "Instalando dependências em ${APP_DIR}"

npm install

log_info "Dependências do app instaladas com sucesso."

log_info "Sincronizando dados do banco de dados para app/assets/data..."
"${ROOT_DIR}/scripts/syncDatabaseAssets.sh" app

log_info "Setup do app concluído com sucesso!"