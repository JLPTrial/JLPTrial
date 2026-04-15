#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"
PLATFORM="${1:-android}"
MODE="${2:-debug}"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "[mobile] Arquivo .env não encontrado em ${ENV_FILE}"
  exit 1
fi


source "${ENV_FILE}"

if [[ -z "${APP_FLAVOR:-}" ]]; then
  echo "[mobile] APP_FLAVOR não definido no .env"
  exit 1
fi

FLAVOR="${APP_FLAVOR}"

require_var() {
  local var_name="$1"
  if [[ -z "${!var_name:-}" ]]; then
    echo "[mobile] Variável obrigatória ausente: ${var_name}"
    exit 1
  fi
}

if [[ "${FLAVOR}" == "prod" ]]; then
  require_var "PROD_MOBILE_API_HOST"
  require_var "PROD_MOBILE_API_PORT"
  API_HOST="${PROD_MOBILE_API_HOST}"
  API_PORT="${PROD_MOBILE_API_PORT}"
elif [[ "${FLAVOR}" == "dev" ]]; then
  require_var "DEV_MOBILE_API_HOST"
  require_var "DEV_MOBILE_API_PORT"
  API_HOST="${DEV_MOBILE_API_HOST}"
  API_PORT="${DEV_MOBILE_API_PORT}"
else
  echo "[mobile] APP_FLAVOR inválido: ${FLAVOR}. Use dev ou prod."
  exit 1
fi

if [[ "${API_PORT}" == "443" ]]; then
  export EXPO_PUBLIC_API_URL="https://${API_HOST}/"
else
  export EXPO_PUBLIC_API_URL="http://${API_HOST}:${API_PORT}/"
fi

cd "${ROOT_DIR}/app"

echo "[mobile] Plataforma=${PLATFORM} Modo=${MODE} Flavor=${FLAVOR}"
echo "[mobile] EXPO_PUBLIC_API_URL=${EXPO_PUBLIC_API_URL}"

"${ROOT_DIR}/scripts/includeMediaApp.sh"

if [[ "${MODE}" == "debug" ]]; then
  if [[ "${PLATFORM}" == "android" ]]; then
    npx expo start --android
  elif [[ "${PLATFORM}" == "ios" ]]; then
    npx expo start --ios
  else
    echo "Uso: scripts/runMobile.sh [android|ios] [debug|release]"
    exit 1
  fi
else
  if [[ "${PLATFORM}" == "android" ]]; then
    npx expo run:android --variant release
  elif [[ "${PLATFORM}" == "ios" ]]; then
    npx expo run:ios --configuration Release
  else
    echo "Uso: scripts/runMobile.sh [android|ios] [debug|release]"
    exit 1
  fi
fi
