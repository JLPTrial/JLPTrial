#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="${ROOT_DIR}/app"
WEB_DIR="${ROOT_DIR}/web"
SERVER_DIR="${ROOT_DIR}/server"

ERRO_BG="\033[0;41m"
APP="\033[0;30;46m"
WEB="\033[0;30;45m"
SERVIDOR="\033[0;30;43m"
JLPTRIAL="\033[0;30;42m"
RESET="\033[0m"

OPT_APP=0
OPT_WEB=0
OPT_SERVER=0
OPT_FIX=0

log_msg() {
    local repo="$1"
    local typ="$2"
    local msg="$3"
    local color
    case "$repo" in
        APP)      color="$APP" ;;
        WEB)      color="$WEB" ;;
        SERVIDOR) color="$SERVIDOR" ;;
        *)        color="$JLPTRIAL" ;;
    esac

    if [[ "$typ" == "err" ]]; then
        echo -e "${ERRO_BG}[${repo}]${RESET} ✗ ${msg}"
    elif [[ "$typ" == "ok" ]]; then
        echo -e "${color}[${repo}]${RESET} ✓ ${msg}"
    else
        echo -e "${color}[${repo}]${RESET} ${msg}"
    fi
}

log_status() { log_msg "$1" "" "$2"; }
log_success() { log_msg "$1" "ok" "$2"; }
log_fail() { log_msg "$1" "err" "$2"; }

log_info()  { echo -e "${JLPTRIAL}[JLPTRIAL]${RESET} $1"; }
log_error() { echo -e "${ERRO_BG}[JLPTRIAL]${RESET} $1"; }

help() {
    echo "Uso: devbox run lint [OPÇÕES]"
    echo ""
    echo "Executa as validações locais para app, web e backend."
    echo "Opções:"
    echo "  --all                Executa todas as validações. Padrão quando nenhum alvo é informado"
    echo "  --app                Executa a validação do app (app/)"
    echo "  --web                Executa a validação do web (web/)"
    echo "  --server, --backend  Executa a validação sintática do backend (server/)"
    echo "  --fix                Aplica correções automáticas quando disponíveis"
    echo "  --help, -h           Exibe essa mensagem de ajuda"
    echo ""
}

run_linter() {
    local repo="$1"
    local dir="$2"
    local check_cmd="$3"
    local fix_cmd="$4"
    local flag="$5"

    [[ ! -d "${dir}" ]] && { log_fail "$repo" "Pasta ${dir##*/} não encontrada"; exit 1; }

    log_status "$repo" "Executando Linter"

    if (cd "$dir" && eval "$check_cmd"); then
        log_success "$repo" "Nenhum problema foi encontrado"
        return 0
    fi

    if [[ ${OPT_FIX} -eq 1 && -n "$fix_cmd" ]]; then
        log_status "$repo" "Corrigindo erros..."
        if (cd "$dir" && eval "$fix_cmd"); then
            if (cd "$dir" && eval "$check_cmd"); then
                log_success "$repo" "Corrigido com sucesso"
                return 0
            else
                log_fail "$repo" "Ainda há erros após correção automática"
                exit 1
            fi
        else
            log_fail "$repo" "Correção falhou (alguns erros não puderam ser corrigidos automáticamente)"
            exit 1
        fi
    else
        log_fail "$repo" "Foram encontrados erros"
        if [[ -n "$flag" ]]; then
            echo "       Execute: devbox run lint --${flag} --fix"
        fi
        exit 1
    fi
}

run_app_lint() {
    run_linter "APP     " "${APP_DIR}" "npx expo lint --" "npx expo lint -- --fix" "app"
}

run_web_lint() {
    run_linter "WEB     " "${WEB_DIR}" "npx eslint ." "npx eslint --fix ." "web"
}

run_server_check() {
    run_linter "SERVIDOR" "${SERVER_DIR}" "python3 -m py_compile src/*.py" "" "server"
}

if [[ $# -eq 0 ]]; then
    OPT_APP=1
    OPT_WEB=1
    OPT_SERVER=1
else
    for arg in "$@"; do
        case "${arg}" in
            --all)
                OPT_APP=1
                OPT_WEB=1
                OPT_SERVER=1
                ;;
            --app)
                OPT_APP=1
                ;;
            --web)
                OPT_WEB=1
                ;;
            --server|--backend)
                OPT_SERVER=1
                ;;
            --fix)
                OPT_FIX=1
                ;;
            --help|-h)
                help
                exit 0
                ;;
            *)
                log_error "Opção inválida: ${arg}"
                help
                exit 1
                ;;
        esac
    done

    if [[ ${OPT_APP} -eq 0 && ${OPT_WEB} -eq 0 && ${OPT_SERVER} -eq 0 ]]; then
        OPT_APP=1
        OPT_WEB=1
        OPT_SERVER=1
    fi
fi

if [[ ${OPT_APP} -eq 1 ]]; then
    run_app_lint
fi

if [[ ${OPT_WEB} -eq 1 ]]; then
    run_web_lint
fi

if [[ ${OPT_SERVER} -eq 1 ]]; then
    run_server_check
fi

log_info "Linting e validações concluídos com sucesso"

exit 0
