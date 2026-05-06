#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="${ROOT_DIR}/server"

ERRO_BG="\033[0;41m"
SERVIDOR="\033[0;30;43m"
RESET="\033[0m"

# Contadores
TOTAL_ISSUES=0
FLAKE8_STATUS=0
PYLINT_STATUS=0
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

# ==================== FLAKE8 ====================
log_status "Executando Flake8"

if (cd "$SERVER_DIR" && python3 -m flake8 src --count --show-source --statistics > /tmp/flake8-output.txt 2>&1); then
    log_success "Flake8 PASSOU"
else
    FLAKE8_STATUS=$?
    log_fail "Flake8 encontrou problemas (veja detalhes abaixo)"
    ((TOTAL_ISSUES++))
fi

# ==================== PYLINT ====================
log_status "Executando Pylint"

if (cd "$SERVER_DIR" && python3 -m pylint src --fail-under=8.0 > /tmp/pylint-output.txt 2>&1); then
    log_success "Pylint PASSOU"
else
    PYLINT_STATUS=$?
    log_fail "Pylint encontrou problemas (veja detalhes abaixo)"
    ((TOTAL_ISSUES++))
fi

# ==================== MYPY ====================
log_status "Executando MyPy"

if (cd "$SERVER_DIR" && python3 -m mypy src --ignore-missing-imports --show-error-codes > /tmp/mypy-output.txt 2>&1); then
    log_success "MyPy PASSOU"
else
    MYPY_STATUS=$?
    log_fail "MyPy encontrou problemas (veja detalhes abaixo)"
    ((TOTAL_ISSUES++))
fi

# ==================== BANDIT ====================
log_status "Executando Bandit"

if (cd "$SERVER_DIR" && python3 -m bandit -r src -f txt > /tmp/bandit-output.txt 2>&1); then
    log_success "Bandit PASSOU"
else
    BANDIT_STATUS=$?
    log_fail "Bandit encontrou problemas de segurança (veja detalhes abaixo)"
    ((TOTAL_ISSUES++))
fi

# ==================== RELATÓRIO FINAL ====================
if [[ $TOTAL_ISSUES -eq 0 ]]; then
    log_success "Nenhum problema foi encontrado"
    exit 0
else
    log_fail "Foram encontrados problemas em $TOTAL_ISSUES verificacao(oes)"
    echo ""
    
    if [[ $FLAKE8_STATUS -ne 0 ]]; then
        echo -e "${SERVIDOR}[SERVIDOR]${RESET} Problemas encontrados por Flake8:"
        cat /tmp/flake8-output.txt
        echo ""
    fi
    
    if [[ $PYLINT_STATUS -ne 0 ]]; then
        echo -e "${SERVIDOR}[SERVIDOR]${RESET} Problemas encontrados por Pylint:"
        cat /tmp/pylint-output.txt
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
