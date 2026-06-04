#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
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

log_info "Executando testes do app em ${APP_DIR}"

if npm run | grep -q " test"; then
  npm test -- --coverage --watchAll=false
else
  log_info "Nenhum script de teste encontrado no app; pulando execução"
fi

log_info "Testes do app concluídos"