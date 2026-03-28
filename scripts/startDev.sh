#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cleanup() {
  if [[ -n "${BACKEND_PID:-}" ]]; then
    kill "${BACKEND_PID}" >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT INT TERM

"${ROOT_DIR}/scripts/startBackend.sh" &
BACKEND_PID=$!

# Pequena espera para reduzir chance de corrida no primeiro fetch do web.
sleep 2

"${ROOT_DIR}/scripts/startWeb.sh"
