#!/bin/sh
set -eu

echo "=== BrowserSkill 自动检查/安装 ==="

if command -v bsk >/dev/null 2>&1; then
  echo "[OK] 已找到 bsk：$(bsk --version 2>/dev/null || true)"
else
  echo "[INFO] 未找到 bsk，开始安装官方版本..."
  curl -fsSL https://raw.githubusercontent.com/Tencent/BrowserSkill/main/install.sh | sh
  export PATH="${BSK_INSTALL_DIR:-$HOME/.local/bin}:$PATH"
fi

if ! command -v bsk >/dev/null 2>&1; then
  echo "[ERROR] bsk 安装后仍无法找到。请重新打开终端后再运行此脚本。"
  exit 1
fi

echo "[OK] bsk：$(bsk --version)"

echo "[INFO] 安装/检查 Agent Skill..."
bsk install-skill --yes || {
  echo "[WARN] 没有检测到可安装的 Agent harness；这不影响 bsk 本体安装。"
}

echo "[INFO] 运行 bsk doctor..."
bsk doctor

echo ""
echo "=== 完成 ==="
echo "如果 doctor 提示 extension connected 失败，请在 Chrome/Edge 安装并启用 BrowserSkill 扩展。"
