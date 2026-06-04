#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ERRO_BG="\033[0;41m"
JLPTRIAL="\033[0;30;42m"
RESET="\033[0m"

log_info() {
  echo -e "${JLPTRIAL}[JLPTRIAL]${RESET} $1"
}

log_error() {
  echo -e "${ERRO_BG}[JLPTRIAL]${RESET} $1"
}

help() {
  echo "Uso: devbox run test [--app|--web|--server|--backend|--all]..."
  echo ""
  echo "Sem argumentos, executa os testes de app, web e backend."
  echo ""
  echo "Exemplos:"
  echo "  devbox run test"
  echo "  devbox run test --app"
  echo "  devbox run test --web --server"
  echo ""
}

run_app() {
  "${ROOT_DIR}/scripts/app/test.sh"
}

run_web() {
  "${ROOT_DIR}/scripts/web/test.sh"
}

run_server() {
  "${ROOT_DIR}/scripts/server/test.sh"
}

RUN_APP=0
RUN_WEB=0
RUN_SERVER=0

if [[ "$#" -eq 0 ]]; then
  RUN_APP=1
  RUN_WEB=1
  RUN_SERVER=1
else
  for arg in "$@"; do
    case "${arg}" in
      --all)
        RUN_APP=1
        RUN_WEB=1
        RUN_SERVER=1
        ;;
      --app)
        RUN_APP=1
        ;;
      --web)
        RUN_WEB=1
        ;;
      --server|--backend)
        RUN_SERVER=1
        ;;
      --help|-h)
        help
        exit 0
        ;;
      *)
        log_error "Argumento inválido: ${arg}"
        help
        exit 1
        ;;
    esac
  done
fi

log_info "Iniciando testes automáticos"

if [[ ${RUN_APP} -eq 1 ]]; then
  run_app
fi

if [[ ${RUN_WEB} -eq 1 ]]; then
  run_web
fi

if [[ ${RUN_SERVER} -eq 1 ]]; then
  run_server
fi

log_info "Testes finalizados :)"