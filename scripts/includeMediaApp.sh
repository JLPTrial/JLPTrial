#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

OUTPUT_FILE="$ROOT_DIR/app/src/constants/assetsMap.ts"
BASE_PATH="$ROOT_DIR/app/assets/data"
LEVELS=("N5" "N4")

echo "export const assetsMap: Record<string, any> = {" > $OUTPUT_FILE

for LVL in "${LEVELS[@]}"; do
    LVL_DIR="$BASE_PATH/$LVL"
    [ ! -d "$LVL_DIR" ] && continue

    find "$LVL_DIR/audios" -name "*.mp3" 2>/dev/null | while read -r file; do
        KEY=$(echo "$file" | sed "s|.*$LVL/audios/||")
        CLEAN_PATH=$(echo "$file" | sed "s|^$ROOT_DIR/app/||")

        REQ="../../$CLEAN_PATH"

        echo "  \"$LVL$KEY\": require(\"$REQ\")," >> $OUTPUT_FILE
    done

    find "$LVL_DIR/images" -name "*.png" 2>/dev/null | while read -r file; do
        KEY=$(echo "$file" | sed "s|.*$LVL/images/||")
        REQ="../../assets/data/$LVL/images/$KEY"

        echo "  \"$LVL$KEY\": require(\"$REQ\")," >> $OUTPUT_FILE
    done
done

echo "};" >> $OUTPUT_FILE
