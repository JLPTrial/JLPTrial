#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WEB_DIR="${ROOT_DIR}/web"

ERRO_BG="\033[0;41m"
WEB="\033[0;30;45m"
RESET="\033[0m"

log_info() {
	echo -e "${WEB}[WEB     ]${RESET} $1"
}

log_error() {
	echo -e "${ERRO_BG}[WEB     ]${RESET} $1"
}

if [[ ! -d "${WEB_DIR}" ]]; then
	log_error "Pasta web não encontrada em ${WEB_DIR}"
	exit 1
fi

cd "${WEB_DIR}"

log_info "Instalando dependências em ${WEB_DIR}"

npm install

log_info "Dependências web instaladas com sucesso."