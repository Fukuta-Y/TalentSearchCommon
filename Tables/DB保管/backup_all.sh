#!/bin/bash

# --- 接続情報 ---
DB_URL="postgresql://neondb_owner:npg_POc5kym8noRC@ep-divine-truth-a1eqa5uj-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require"

# --- デスクトップのパス ---
DEST_DIR="$HOME/Desktop"
FILENAME="neon_full_backup_$(date +%Y%m%d_%H%M%S).sql"
OUTPUT_PATH="${DEST_DIR}/${FILENAME}"

echo "Neonの全テーブルを抽出中..."

# --- pg_dump 実行 (Mac/古いバージョン対応版) ---
# --column-inserts: INSERT文形式
# --clean: DROP TABLE文を含める (add-drop-tableの代わり)
pg_dump "$DB_URL" \
  --column-inserts \
  --clean \
  --if-exists \
  > "$OUTPUT_PATH"

if [ $? -eq 0 ]; then
  echo "--------------------------------------------------"
  echo "成功！デスクトップに保存されました。"
  echo "ファイル名: $FILENAME"
  echo "--------------------------------------------------"
else
  echo "エラーが発生しました。"
fi
