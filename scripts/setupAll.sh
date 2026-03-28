#!/usr/bin/env bash

## Script para setup do ambiente de desenvolvimento do JLPTrial
## Execute com: devbox run setup
##
## Etapas do setup completo:
## 1. Inicialização/configuração do banco de dados local (SQLite)
## 2. Instalação das dependências do app
## 3. Instalação das dependências do servidor
## 4. Instalação das dependências do frontend web

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ERRO="\033[0;31m"
ERRO_BG="\033[0;41m"
APP="\033[0;30;46m"
SERVIDOR="\033[0;30;43m"
BANCO="\033[0;30;47m"
WEB="\033[0;30;45m"
JLPTRIAL="\033[0;30;42m"
RESET="\033[0m"

log_info() {
	echo -e "${JLPTRIAL}[JLPTRIAL]${RESET} $1"
}

log_error() {
	echo -e "${ERRO_BG}[JLPTRIAL]${RESET} $1"
}

help() {
	echo "Uso: devbox run setup"
	echo ""
	echo "Configura o ambiente de desenvolvimento do JLPTrial."
	echo ""
	echo "Fluxo padrão:"
	echo "1. Configura banco de dados local"
	echo "2. Instala dependências do app"
	echo "3. Instala dependências do backend"
	echo "4. Instala dependências do web"
	echo ""
	echo "Para setup de partes específicas, execute diretamente os scripts (ou os comandos do devbox):"
	echo "- Banco:   scripts/databaseSetup.sh   | devbox run setupDatabase"
	echo "- App:     scripts/appSetup.sh        | devbox run setupApp"
	echo "- Backend: scripts/backendSetup.sh    | devbox run setupBackend"
	echo "- Android: scripts/androidSetup.sh    | devbox run setupAndroid"
	echo "- Web:     scripts/webSetup.sh        | devbox run setupWeb"
	echo ""
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
	help
	exit 0
fi

if [[ "$#" -gt 0 ]]; then
	log_error "Este script não precisa de parâmetros extras. Caso precise instalar algo específico, Use --help para ver os scripts específicos."
	exit 1
fi

log_info "Iniciando setup automático"

if [[ ! -f "${ROOT_DIR}/.env" ]]; then
	log_error "Arquivo .env não encontrado. Crie a partir do .env.example e execute novamente."
	exit 1
fi

echo -e "${APP}[APP     ]${RESET} Inicializando bancos de dados"
"${ROOT_DIR}/scripts/setupDB.sh"

echo -e "${APP}[APP     ]${RESET} Instalando dependências do app"
"${ROOT_DIR}/scripts/setupApp.sh"

echo -e "${SERVIDOR}[SERVIDOR]${RESET} Instalando dependências do backend"
"${ROOT_DIR}/scripts/setupBackend.sh"

echo -e "${WEB}[WEB     ]${RESET} Instalando dependências do web"
"${ROOT_DIR}/scripts/setupWeb.sh"

log_info "Setup finalizado :)"
