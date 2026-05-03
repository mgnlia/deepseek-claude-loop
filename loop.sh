#!/usr/bin/env bash
set -euo pipefail

MODEL="${CLAUDE_LOOP_MODEL:-deepseek-v4-pro}"
TASK="${1:-}"
INTERVAL="${CLAUDE_LOOP_INTERVAL:-0}"
MAX_LOOPS="${CLAUDE_LOOP_MAX_LOOPS:-}"

if [ -z "$TASK" ]; then
  echo "Usage: loop.sh <task-description>"
  echo ""
  echo "Env vars:"
  echo "  CLAUDE_LOOP_MODEL        Model to use (default: deepseek-v4-pro)"
  echo "  CLAUDE_LOOP_INTERVAL     Seconds between loops (default: 0)"
  echo "  CLAUDE_LOOP_MAX_LOOPS    Max iterations (default: unlimited)"
  echo ""
  echo "Example:"
  echo "  loop.sh 'Fix all lint errors in src/'"
  exit 1
fi

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  echo "Error: ANTHROPIC_API_KEY not set."
  echo "Export it or source your env: export ANTHROPIC_API_KEY=sk-..."
  exit 1
fi

export ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-https://api.deepseek.com/anthropic}"

echo "=== Claude Code Loop ==="
echo "Model:      $MODEL"
echo "Task:       $TASK"
echo "Interval:   ${INTERVAL}s"
echo "Max loops:  ${MAX_LOOPS:-unlimited}"
echo "========================="
echo ""

COUNT=0
FIRST=true

while true; do
  COUNT=$((COUNT + 1))

  if [ -n "$MAX_LOOPS" ] && [ "$COUNT" -gt "$MAX_LOOPS" ]; then
    echo "[loop] Max iterations ($MAX_LOOPS) reached. Done."
    break
  fi

  echo "[loop #$COUNT] $(date '+%Y-%m-%d %H:%M:%S')"

  if [ "$FIRST" = true ]; then
    claude -p "$TASK" \
      --model "$MODEL" \
      --bare \
      --dangerously-skip-permissions \
      --no-session-persistence \
      --allowedTools "Bash,Read,Edit,Write,Glob,Grep,WebSearch,WebFetch,Task" \
      2>&1
    FIRST=false
  else
    claude -p "Continue working on: $TASK" \
      --model "$MODEL" \
      --bare \
      --dangerously-skip-permissions \
      --no-session-persistence \
      --continue \
      --allowedTools "Bash,Read,Edit,Write,Glob,Grep,WebSearch,WebFetch,Task" \
      2>&1
  fi

  echo ""
  echo "[loop #$COUNT] complete."

  if [ -n "$INTERVAL" ] && [ "$INTERVAL" -gt 0 ]; then
    echo "[loop] sleeping ${INTERVAL}s..."
    sleep "$INTERVAL"
  fi
done
