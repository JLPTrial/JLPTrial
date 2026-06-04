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

if [[ -z "${ANDROID_HOME:-}" ]]; then
    log_info "ANDROID_HOME não está definido. Verifique seu .env/devbox.json"
else
    export PATH="${PATH}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools"
    echo -e "${APP}[APP     ]${RESET} Android SDK detectado em ${ANDROID_HOME}"

    if [[ ! -d "${ANDROID_HOME}/platforms/android-28" ]]; then
        log_error "Android SDK API 28 (Android 9) não encontrado em ${ANDROID_HOME}/platforms/android-28"
        log_error "Instale o pacote 'Android SDK Platform 28' no Android Studio (SDK Manager)."
        exit 1
    fi
fi

log_info "Preparando dependências do app"
"${ROOT_DIR}/scripts/app/setupApp.sh"

cd "${APP_DIR}"
log_info "Ambiente Android preparado. Para iniciar: npm run android"