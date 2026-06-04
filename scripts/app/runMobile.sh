#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PLATFORM="${1:-android}"
MODE="${2:-debug}"

ERRO_BG="\033[0;41m"
APP="\033[0;30;46m"
RESET="\033[0m"

log_info() {
  echo -e "${APP}[APP     ]${RESET} $1"
}

log_error() {
  echo -e "${ERRO_BG}[APP     ]${RESET} $1"
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
  log_error "APP_FLAVOR inválido: ${FLAVOR}. Use dev ou prod."
  exit 1
fi

if [[ "${API_PORT}" == "443" ]]; then
  export EXPO_PUBLIC_API_URL="https://${API_HOST}/"
else
  export EXPO_PUBLIC_API_URL="http://${API_HOST}:${API_PORT}/"
fi

cd "${ROOT_DIR}/app"

log_info "Plataforma=${PLATFORM} Modo=${MODE} Flavor=${FLAVOR}"
log_info "EXPO_PUBLIC_API_URL=${EXPO_PUBLIC_API_URL}"

"${ROOT_DIR}/scripts/app/includeMediaApp.sh"

if [[ "${MODE}" == "debug" ]]; then
  if [[ "${PLATFORM}" == "android" ]]; then
    npx expo start --android
  else
    log_error "Plataforma inválida: ${PLATFORM}. Use android"
    exit 1
  fi
else
  if [[ "${PLATFORM}" == "android" ]]; then
    npx expo run:android --variant release
  else
    log_error "Plataforma inválida: ${PLATFORM}. Use android"
    exit 1
  fi
fi
