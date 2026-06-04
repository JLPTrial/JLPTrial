#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SERVER_DIR="${ROOT_DIR}/server"
PYTHON_BIN="${PYTHON_BIN:-python}"

ERRO_BG="\033[0;41m"
SERVIDOR="\033[0;30;43m"
RESET="\033[0m"

FIX=0
for a in "$@"; do
    case "$a" in
        --fix) FIX=1 ;;
    esac
done

# Contadores
TOTAL_ISSUES=0
MYPY_STATUS=0
BANDIT_STATUS=0

log_msg() {
    local typ="$1"
    local msg="$2"

    if [[ "$typ" == "err" ]]; then
        echo -e "${ERRO_BG}[SERVIDOR]${RESET} $msg"
    elif [[ "$typ" == "ok" ]]; then
        echo -e "${SERVIDOR}[SERVIDOR]${RESET} $msg"
    else
        echo -e "${SERVIDOR}[SERVIDOR]${RESET} $msg"
    fi
}

log_status() { log_msg "" "$1"; }
log_success() { log_msg "ok" "$1"; }
log_fail() { log_msg "err" "$1"; }

if [[ ! -d "${SERVER_DIR}" ]]; then
    log_fail "Pasta server não encontrada em ${SERVER_DIR}"
    exit 1
fi

if [[ ! -d "${SERVER_DIR}/src" ]]; then
    log_fail "Pasta src não encontrada em ${SERVER_DIR}"
    exit 1
fi

# ==================== RUFF ====================
if [[ ${FIX} -eq 1 ]]; then
    log_status "Executando ruff check --fix e ruff format no servidor"
    (
    cd "${SERVER_DIR}"
    "${PYTHON_BIN}" -m ruff check src --fix
    "${PYTHON_BIN}" -m ruff format src
    )

    log_status "Formatação do servidor concluída com sucesso"
fi

log_status "Executando Ruff"

if (cd "$SERVER_DIR" && "${PYTHON_BIN}" -m ruff check src > /tmp/ruff-output.txt 2>&1); then
    log_success "Ruff PASSOU"
else
    RUFF_STATUS=$?
    log_fail "Ruff encontrou problemas (veja detalhes abaixo)"
    TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
fi

if (cd "$SERVER_DIR" && "${PYTHON_BIN}" -m ruff format --check src > /tmp/ruff-format-output.txt 2>&1); then
    log_success "Ruff formatação PASSOU"
else
    RUFF_FORMAT_STATUS=$?
    log_fail "Ruff formatação falhou (veja detalhes abaixo)"
    TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
fi

# ==================== MYPY ====================
log_status "Executando MyPy"

if (cd "$SERVER_DIR" && "${PYTHON_BIN}" -m mypy src --ignore-missing-imports --show-error-codes > /tmp/mypy-output.txt 2>&1); then
    log_success "MyPy PASSOU"
else
    MYPY_STATUS=$?
    log_fail "MyPy encontrou problemas (veja detalhes abaixo)"
    TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
fi

# ==================== BANDIT ====================
log_status "Executando Bandit"

if (cd "$SERVER_DIR" && "${PYTHON_BIN}" -m bandit -r src -f txt > /tmp/bandit-output.txt 2>&1); then
    log_success "Bandit PASSOU"
else
    BANDIT_STATUS=$?
    log_fail "Bandit encontrou problemas de segurança (veja detalhes abaixo)"
    TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
fi

# ==================== RELATÓRIO FINAL ====================
if [[ $TOTAL_ISSUES -eq 0 ]]; then
    log_success "Nenhum problema foi encontrado"
    exit 0
else
    log_fail "Foram encontrados problemas em $TOTAL_ISSUES verificacao(oes)"
    echo ""
    
    if [[ ${RUFF_STATUS:-0} -ne 0 ]]; then
        echo -e "${SERVIDOR}[SERVIDOR]${RESET} Problemas encontrados por Ruff:"
        cat /tmp/ruff-output.txt
        echo ""
    fi

    if [[ ${RUFF_FORMAT_STATUS:-0} -ne 0 ]]; then
        echo -e "${SERVIDOR}[SERVIDOR]${RESET} Problemas de formatação (ruff format):"
        cat /tmp/ruff-format-output.txt
        echo ""
    fi
    
    if [[ $MYPY_STATUS -ne 0 ]]; then
        echo -e "${SERVIDOR}[SERVIDOR]${RESET} Problemas encontrados por MyPy:"
        cat /tmp/mypy-output.txt
        echo ""
    fi
    
    if [[ $BANDIT_STATUS -ne 0 ]]; then
        echo -e "${SERVIDOR}[SERVIDOR]${RESET} Problemas de segurança encontrados por Bandit:"
        cat /tmp/bandit-output.txt
        echo ""
    fi
    
    exit 1
fi
