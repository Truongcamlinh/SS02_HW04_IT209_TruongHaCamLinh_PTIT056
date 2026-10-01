#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Vui lòng chạy bằng sudo: sudo ./configure-ufw.sh" >&2
    exit 1
fi

if ! command -v ufw >/dev/null 2>&1; then
    apt update
    apt install -y ufw
fi

# Mở SSH trước khi bật firewall để không tự khóa phiên quản trị hiện tại.
ufw allow 22/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP'

ufw default deny incoming
ufw default allow outgoing
ufw --force enable

echo
ufw status verbose
