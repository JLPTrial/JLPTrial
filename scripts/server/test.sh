#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SERVER_DIR="${ROOT_DIR}/server"

if [[ ! -d "${SERVER_DIR}" ]]; then
  echo "Pasta server não encontrada: ${SERVER_DIR}"
  exit 1
fi

echo "Executando testes do servidor com cobertura..."
(
  cd "${SERVER_DIR}"
  coverage run -m pytest tests/
  coverage report
)

echo "Testes concluídos"
