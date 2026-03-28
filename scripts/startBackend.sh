#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "[backend] Arquivo .env não encontrado em ${ENV_FILE}"
  exit 1
fi

source "${ENV_FILE}"

if [[ -z "${APP_FLAVOR:-}" ]]; then
  echo "[backend] APP_FLAVOR não definido no .env"
  exit 1
fi

FLAVOR="${APP_FLAVOR}"

require_var() {
  local var_name="$1"
  if [[ -z "${!var_name:-}" ]]; then
    echo "[backend] Variável obrigatória ausente: ${var_name}"
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
  echo "[backend] APP_FLAVOR inválido: ${FLAVOR}. Use dev ou prod."
  exit 1
fi

cd "${ROOT_DIR}/server"

echo "[backend] Sincronizando dados do banco de dados..."
"${ROOT_DIR}/scripts/syncDatabaseAssets.sh" server

echo "[backend] Iniciando em ${HOST}:${PORT} (flavor=${FLAVOR})"
python3 -m uvicorn src.main:app --host "${HOST}" --port "${PORT}" --reload
