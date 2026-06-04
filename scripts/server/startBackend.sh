#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

ERRO_BG="\033[0;41m"
BACKEND="\033[0;30;43m"
RESET="\033[0m"

log_info() {
  echo -e "${BACKEND}[BACKEND ]${RESET} $1"
}

log_error() {
  echo -e "${ERRO_BG}[BACKEND ]${RESET} $1"
}

source "${ROOT_DIR}/.env"

if [[ -z "${APP_FLAVOR:-}" ]]; then
  log_error "APP_FLAVOR não definido no .env"
  exit 1
fi

FLAVOR="${APP_FLAVOR}"

require_var() {
  local var_name="$1"
  if [[ -z "${!var_name:-}" ]]; then
    log_error "Variável obrigatória ausente: ${var_name}"
    exit 1
  fi
}

if [[ "${FLAVOR}" == "prod" ]]; then
  require_var "PROD_BACKEND_HOST"
  require_var "PROD_BACKEND_PORT"
  HOST="${PROD_BACKEND_HOST}"
  PORT="${PROD_BACKEND_PORT}"
elif [[ "${FLAVOR}" == "dev" ]]; then
  require_var "DEV_BACKEND_HOST"
  require_var "DEV_BACKEND_PORT"
  HOST="${DEV_BACKEND_HOST}"
  PORT="${DEV_BACKEND_PORT}"
else
  log_error "APP_FLAVOR inválido: ${FLAVOR}. Use dev ou prod."
  exit 1
fi

cd "${ROOT_DIR}/server"

log_info "Sincronizando dados do banco de dados..."
"${ROOT_DIR}/scripts/database/syncDatabaseAssets.sh" server

log_info "Iniciando em ${HOST}:${PORT} (flavor=${FLAVOR})"
python3 -m uvicorn src.main:app --host "${HOST}" --port "${PORT}" --reload
