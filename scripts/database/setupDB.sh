#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCHEMA_PATH="${ROOT_DIR}/database/schemas/question_schema.sql"
SOURCE_DIR="${ROOT_DIR}/database/data"
OUTPUT_DIR="${ROOT_DIR}/database/outputs"
PYTHON_DB_BUILDER="${ROOT_DIR}/database/scripts/build_level_db.py"
LEVEL_ORDER=("N5" "N4" "N3" "N2" "N1")

ERRO_BG="\033[0;41m"
BANCO="\033[0;30;47m"
RESET="\033[0m"

log_info() {
  echo -e "${BANCO}[BANCO   ]${RESET} $1"
}

log_error() {
  echo -e "${ERRO_BG}[BANCO   ]${RESET} $1"
}

show_examples() {
  echo "Exemplos de uso:"
  echo "  scripts/database/setupDB.sh"
  echo "  scripts/database/setupDB.sh N5"
  echo "  scripts/database/setupDB.sh N5 N4"
}

validate_prerequisites() {
  if [[ ! -f "${SCHEMA_PATH}" ]]; then
    log_error "Schema não encontrado: ${SCHEMA_PATH}"
    exit 1
  fi

  if [[ ! -f "${PYTHON_DB_BUILDER}" ]]; then
    log_error "Script Python não encontrado: ${PYTHON_DB_BUILDER}"
    exit 1
  fi

  if [[ ! -d "${SOURCE_DIR}" ]]; then
    log_error "Pasta de dados não encontrada: ${SOURCE_DIR}"
    exit 1
  fi
}

is_valid_level() {
  local level="$1"
  case "${level}" in
  N1 | N2 | N3 | N4 | N5)
    return 0
    ;;
  *)
    return 1
    ;;
  esac
}

collect_all_available_levels() {
  local levels=()
  local level
  for level in "${LEVEL_ORDER[@]}"; do
    if [[ -d "${SOURCE_DIR}/${level}/data" ]]; then
      levels+=("${level}")
    fi
  done
  printf '%s\n' "${levels[@]}"
}

prepare_output_dir() {
  local level="$1"
  mkdir -p "${OUTPUT_DIR}/${level}"
}

copy_level_assets() {
  local level="$1"
  local source_level_dir="${SOURCE_DIR}/${level}"
  local output_level_dir="${OUTPUT_DIR}/${level}"

  if [[ -d "${source_level_dir}/audios" ]]; then
    rm -rf "${output_level_dir}/audios"
    cp -r "${source_level_dir}/audios" "${output_level_dir}/"
  fi

  if [[ -d "${source_level_dir}/images" ]]; then
    rm -rf "${output_level_dir}/images"
    cp -r "${source_level_dir}/images" "${output_level_dir}/"
  fi
}

run_python_db_builder() {
  local level="$1"
  local source_level_data_dir="${SOURCE_DIR}/${level}/data"
  local db_path="${OUTPUT_DIR}/${level}/${level}.db"

  python3 "${PYTHON_DB_BUILDER}" \
    --schema "${SCHEMA_PATH}" \
    --db "${db_path}" \
    --data-dir "${source_level_data_dir}"
}

build_level_db() {
  local level="$1"
  local source_level_data_dir="${SOURCE_DIR}/${level}/data"
  local db_path="${OUTPUT_DIR}/${level}/${level}.db"

  if [[ ! -d "${source_level_data_dir}" ]]; then
    log_error "Dados do nível ${level} não encontrados em ${source_level_data_dir}"
    exit 1
  fi

  log_info "Preparando output para ${level}..."
  prepare_output_dir "${level}"

  if [[ -f "${db_path}" ]]; then
    log_info "Removendo banco anterior: ${db_path}"
    rm -f "${db_path}"
  fi

  log_info "Copiando assets de ${level}..."
  copy_level_assets "${level}"

  log_info "Construíndo ${level}.db via script Python..."
  run_python_db_builder "${level}"

  log_info "Nível ${level} concluído em ${OUTPUT_DIR}/${level}/"
}

main() {
  validate_prerequisites

  local requested_levels=()
  local arg

  if [[ $# -eq 0 ]]; then
    while IFS= read -r level; do
      [[ -n "${level}" ]] && requested_levels+=("${level}")
    done < <(collect_all_available_levels)

    if [[ "${#requested_levels[@]}" -eq 0 ]]; then
      log_error "Nenhum nível com dados disponível em ${SOURCE_DIR} (N5..N1)."
      exit 1
    fi
    
  else
    for arg in "$@"; do
      if ! is_valid_level "${arg}"; then
        log_error "Argumento inválido: ${arg}"
        show_examples
        exit 1
      fi
      requested_levels+=("${arg}")
    done
  fi

  log_info "Níveis para geração: ${requested_levels[*]}"
  for level in "${requested_levels[@]}"; do
    build_level_db "${level}"
  done
}

main "$@"