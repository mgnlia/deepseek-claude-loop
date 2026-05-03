#!/usr/bin/env bash
set -euo pipefail

echo "=== DeepSeek + Claude Code Loop Setup ==="
echo ""

# Check node
if ! command -v node &>/dev/null; then
  echo "Node.js not found. Install Node >= 22 first."
  exit 1
fi
echo "[OK] Node $(node --version)"

# Install Claude Code
if ! command -v claude &>/dev/null; then
  echo "[...] Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
else
  echo "[OK] Claude Code $(claude --version | head -1)"
fi

# Prompt for API key
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  read -rsp "Enter DeepSeek API key (sk-...): " API_KEY
  echo ""
else
  echo "[OK] ANTHROPIC_API_KEY already set"
fi

# Write env config
CONFIG_DIR="${HOME}/.config/deepseek-claude-loop"
mkdir -p "$CONFIG_DIR"

if [ -n "${API_KEY:-}" ]; then
  cat > "$CONFIG_DIR/env" <<EOF
export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
export ANTHROPIC_API_KEY=$API_KEY
EOF
  chmod 600 "$CONFIG_DIR/env"
  echo "[OK] Wrote $CONFIG_DIR/env"
fi

# Make loop.sh executable
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
chmod +x "$SCRIPT_DIR/loop.sh"

echo ""
echo "=== Setup complete ==="
echo ""
echo "To load env:  source $CONFIG_DIR/env"
echo "To run:       ./loop.sh 'Your task description'"
echo ""
echo "Env vars for tuning:"
echo "  CLAUDE_LOOP_MODEL     (default: deepseek-v4-pro)"
echo "  CLAUDE_LOOP_INTERVAL  seconds between loops (default: 0)"
echo "  CLAUDE_LOOP_MAX_LOOPS max iterations (default: unlimited)"
