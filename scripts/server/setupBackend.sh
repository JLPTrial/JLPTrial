#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"
SERVER_DIR="${ROOT_DIR}/server"

ERRO_BG="\033[0;41m"
SERVIDOR="\033[0;30;43m"
RESET="\033[0m"

log_info() {
  echo -e "${SERVIDOR}[SERVIDOR]${RESET} $1"
}

log_error() {
  echo -e "${ERRO_BG}[SERVIDOR]${RESET} $1"
}

if [[ ! -d "${SERVER_DIR}" ]]; then
  log_error "Pasta server não encontrada em ${SERVER_DIR}"
  exit 1
fi

if [[ ! -d "${VENV_DIR}" ]]; then
  log_info "Criando ambiente virtual em ${VENV_DIR}"
  python3 -m venv "${VENV_DIR}"
fi

source "${VENV_DIR}/bin/activate"
python -m pip install --upgrade pip
python -m pip install -r "${SERVER_DIR}/requirements.txt"

log_info "Dependencias do SERVIDORinstaladas com sucesso."

log_info "Sincronizando dados do banco de dados..."
"${ROOT_DIR}/scripts/database/syncDatabaseAssets.sh" server

log_info "Setup do SERVIDORconcluído com sucesso!"
