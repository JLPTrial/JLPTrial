#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "[web] Arquivo .env não encontrado em ${ENV_FILE}"
  exit 1
fi


source "${ENV_FILE}"

if [[ -z "${APP_FLAVOR:-}" ]]; then
  echo "[web] APP_FLAVOR não definido no .env"
  exit 1
fi

FLAVOR="${APP_FLAVOR}"

require_var() {
  local var_name="$1"
  if [[ -z "${!var_name:-}" ]]; then
    echo "[web] Variável obrigatória ausente: ${var_name}"
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
  echo "[web] APP_FLAVOR inválido: ${FLAVOR}. Use dev ou prod."
  exit 1
fi

cd "${ROOT_DIR}/web"

export VITE_API_URL="http://${API_HOST}:${API_PORT}/"

echo "[web] Iniciando em ${WEB_HOST}:${WEB_PORT} (flavor=${FLAVOR})"
echo "[web] Consumindo API em ${VITE_API_URL}"
npm run dev -- --host "${WEB_HOST}" --port "${WEB_PORT}"
