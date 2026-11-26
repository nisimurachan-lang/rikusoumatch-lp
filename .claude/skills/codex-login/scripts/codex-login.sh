#!/usr/bin/env bash
# Codex CLI の ChatGPT ログインを1コマンドで行う（冪等）。
# - Codex CLI が無ければインストール
# - ログイン済みなら何もしない
# - 未ログインならデバイスコード方式を開始し、URLとコードを表示する
set -euo pipefail

LOG="${CODEX_LOGIN_LOG:-${TMPDIR:-/tmp}/codex-login.log}"

if ! command -v codex >/dev/null 2>&1; then
  echo "[codex-login] Codex CLI が無いのでインストールします"
  npm install -g @openai/codex >/dev/null
fi
echo "[codex-login] $(codex --version)"

if codex login status 2>&1 | grep -qi "logged in" && ! codex login status 2>&1 | grep -qi "not logged in"; then
  echo "[codex-login] ログイン済みです: $(codex login status 2>&1)"
  exit 0
fi

# 通信チェック（クラウド環境の許可ホスト不足を早期に検出）
for h in auth.openai.com chatgpt.com api.openai.com; do
  code=$(curl -sS -o /dev/null -w "%{http_code}" "https://$h/" 2>/dev/null || true)
  if [ "$code" = "000" ]; then
    echo "[codex-login] NG: $h に接続できません。環境の許可ホストに auth.openai.com / chatgpt.com / api.openai.com を追加してください"
    exit 2
  fi
done

pkill -f "codex login --device-auth" 2>/dev/null || true
setsid codex login --device-auth >"$LOG" 2>&1 &

for _ in $(seq 1 30); do
  grep -qE "[A-Z0-9]{4}-[A-Z0-9]{4,}|Error" "$LOG" && break
  sleep 1
done
sed 's/\x1b\[[0-9;]*m//g' "$LOG"
echo
echo "[codex-login] 上のURLを開いてコードを入力してください（15分有効）。完了後: codex login status"
