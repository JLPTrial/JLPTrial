#!/usr/bin/env python3

import argparse
import sqlite3
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Cria o banco SQLite de um nível.")
    parser.add_argument("--schema", required=True, help="Caminho do schema SQL")
    parser.add_argument("--db", required=True, help="Caminho do .db de saída")
    parser.add_argument("--data-dir", required=True, help="Pasta de dados do nível")
    return parser.parse_args()


def validate_inputs(schema_path: Path, data_dir: Path) -> None:
    if not schema_path.is_file():
        raise FileNotFoundError(f"Schema não encontrado: {schema_path}")
    if not data_dir.is_dir():
        raise FileNotFoundError(f"Pasta de dados não encontrada: {data_dir}")


def create_database(schema_path: Path, db_path: Path) -> None:
    db_path.parent.mkdir(parents=True, exist_ok=True)
    schema_sql = schema_path.read_text(encoding="utf-8")

    conn = sqlite3.connect(str(db_path))
    try:
        conn.executescript(schema_sql)
        conn.commit()
    finally:
        conn.close()


def main() -> None:
    args = parse_args()

    schema_path = Path(args.schema)
    db_path = Path(args.db)
    data_dir = Path(args.data_dir)

    validate_inputs(schema_path, data_dir)
    create_database(schema_path, db_path)


if __name__ == "__main__":
    main()
