#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

ERRO_BG="\033[0;41m"
WEB="\033[0;30;45m"
RESET="\033[0m"

log_info() {
  echo -e "${WEB}[WEB     ]${RESET} $1"
}

log_error() {
  echo -e "${ERRO_BG}[WEB     ]${RESET} $1"
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
  require_var "PROD_WEB_HOST"
  require_var "PROD_WEB_PORT"
  require_var "PROD_BACKEND_HOST"
  require_var "PROD_BACKEND_PORT"
  WEB_HOST="${PROD_WEB_HOST}"
  WEB_PORT="${PROD_WEB_PORT}"
  API_HOST="${PROD_BACKEND_HOST}"
  API_PORT="${PROD_BACKEND_PORT}"
elif [[ "${FLAVOR}" == "dev" ]]; then
  require_var "DEV_WEB_HOST"
  require_var "DEV_WEB_PORT"
  require_var "DEV_BACKEND_HOST"
  require_var "DEV_BACKEND_PORT"
  WEB_HOST="${DEV_WEB_HOST}"
  WEB_PORT="${DEV_WEB_PORT}"
  API_HOST="${DEV_BACKEND_HOST}"
  API_PORT="${DEV_BACKEND_PORT}"
else
  log_error "APP_FLAVOR inválido: ${FLAVOR}. Use dev ou prod."
  exit 1
fi

cd "${ROOT_DIR}/web"

export VITE_API_URL="http://${API_HOST}:${API_PORT}/"

log_info "Iniciando em ${WEB_HOST}:${WEB_PORT} (flavor=${FLAVOR})"
log_info "Consumindo API em ${VITE_API_URL}"
npm run dev -- --host "${WEB_HOST}" --port "${WEB_PORT}"
