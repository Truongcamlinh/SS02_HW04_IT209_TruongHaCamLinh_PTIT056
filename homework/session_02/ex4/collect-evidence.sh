#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/ufw-status.txt"

if [[ "${EUID}" -ne 0 ]]; then
    echo "Vui lòng chạy bằng sudo: sudo ./collect-evidence.sh" >&2
    exit 1
fi

{
    echo "Thời điểm kiểm tra: $(date --iso-8601=seconds)"
    echo "Máy chủ: $(hostname)"
    echo
    ufw status verbose
} | tee "$OUTPUT_FILE"

echo
echo "Đã lưu bằng chứng thật tại: $OUTPUT_FILE"
