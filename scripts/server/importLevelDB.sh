#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SERVER_DIR="${ROOT_DIR}/server"

ERRO_BG="\033[0;41m"
IMPORT_BG="\033[0;30;43m"
RESET="\033[0m"

log_info() {
  echo -e "${IMPORT_BG}[IMPORT  ]${RESET} $1"
}

log_error() {
  echo -e "${ERRO_BG}[IMPORT  ]${RESET} $1"
}

usage() {
  echo "Importa os bancos de nível (N4.db, N5.db, ...) para o banco unificado do servidor."
  echo ""
  echo "Uso:"
  echo "  scripts/server/importLevelDB.sh          # importa todos os níveis em server/data"
  echo "  scripts/server/importLevelDB.sh N5"
  echo "  scripts/server/importLevelDB.sh N5 N4"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

cd "${SERVER_DIR}"

if [[ $# -gt 0 ]]; then
  LEVELS=("$@")
else
  LEVELS=()
  for db_file in data/N*/N*.db; do
    [[ -f "${db_file}" ]] && LEVELS+=("$(basename "${db_file}" .db)")
  done
fi

if [[ ${#LEVELS[@]} -eq 0 ]]; then
  log_error "Nenhum banco de nível encontrado em ${SERVER_DIR}/data (rode o sync antes)."
  exit 1
fi

for LEVEL in "${LEVELS[@]}"; do
  DB_FILE="data/${LEVEL}/${LEVEL}.db"
  if [[ ! -f "${DB_FILE}" ]]; then
    log_error "Banco de origem não encontrado: server/${DB_FILE}"
    exit 1
  fi
  log_info "Importando ${LEVEL} para o banco unificado..."
  python3 -m src.scripts.import_level_db "${DB_FILE}" "${LEVEL}"
done

log_info "Importação concluída!"
