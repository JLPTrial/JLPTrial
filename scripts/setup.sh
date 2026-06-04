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
	echo "Uso: devbox run setup [--web|--db|--database|--app|--server|--all]..."
	echo ""
	echo "Sem argumentos, executa banco de dados, app, server e web."
	echo ""
	echo "Exemplos:"
	echo "  devbox run setup"
	echo "  devbox run setup --app"
	echo "  devbox run setup --web --server"
	echo ""
}

run_database() {
	"${ROOT_DIR}/scripts/database/setupDB.sh"
}

run_app() {
	"${ROOT_DIR}/scripts/app/setupApp.sh"
}

run_server() {
	"${ROOT_DIR}/scripts/server/setupBackend.sh"
}

run_web() {
	"${ROOT_DIR}/scripts/web/setupWeb.sh"
}

RUN_DATABASE=0
RUN_APP=0
RUN_SERVER=0
RUN_WEB=0

if [[ "$#" -eq 0 ]]; then
	RUN_DATABASE=1
	RUN_APP=1
	RUN_SERVER=1
	RUN_WEB=1
else
	for arg in "$@"; do
		case "${arg}" in
			--all)
				RUN_DATABASE=1
				RUN_APP=1
				RUN_SERVER=1
				RUN_WEB=1
				;;
			--db|--database)
				RUN_DATABASE=1
				;;
			--app)
				RUN_APP=1
				;;
			--server)
				RUN_SERVER=1
				;;
			--web)
				RUN_WEB=1
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

log_info "Iniciando setup automático"

if [[ ${RUN_DATABASE} -eq 1 ]]; then
	run_database
fi

if [[ ${RUN_APP} -eq 1 ]]; then
	run_app
fi

if [[ ${RUN_SERVER} -eq 1 ]]; then
	run_server
fi

if [[ ${RUN_WEB} -eq 1 ]]; then
	run_web
fi

log_info "Setup finalizado :)"
