#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"
BACKEND_DIR="${ROOT_DIR}/server"

if [[ ! -d "${BACKEND_DIR}" ]]; then
  echo "[backendSetup] Pasta server nao encontrada em ${BACKEND_DIR}"
  exit 1
fi

if [[ ! -d "${VENV_DIR}" ]]; then
  echo "[backendSetup] Criando ambiente virtual em ${VENV_DIR}"
  python3 -m venv "${VENV_DIR}"
fi

source "${VENV_DIR}/bin/activate"
python -m pip install --upgrade pip
python -m pip install -r "${BACKEND_DIR}/requirements.txt"

echo "[backendSetup] Dependencias do backend instaladas com sucesso."

echo "[backendSetup] Sincronizando dados do banco de dados..."
"${ROOT_DIR}/scripts/syncDatabaseAssets.sh" server

echo "[backendSetup] Setup do backend concluído com sucesso!"
