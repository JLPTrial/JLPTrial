#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYNC_SCRIPT="${ROOT_DIR}/database/scripts/sync_data.py"

SYNC_BG="\033[0;30;43m"
RESET="\033[0m"

log_sync() {
  echo -e "${SYNC_BG}[SYNC    ]${RESET} $1"
}

if [[ ! -f "${SYNC_SCRIPT}" ]]; then
  echo -e "${SYNC_BG}[SYNC    ]${RESET} Arquivo de sincronização não encontrado: ${SYNC_SCRIPT}"
  exit 1
fi

TARGET="${1:-all}"

log_sync "Sincronizando dados de database/outputs para assets..."
python3 "${SYNC_SCRIPT}" "${TARGET}"

log_sync "Sincronização concluída!"
