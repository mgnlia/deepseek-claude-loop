# DeepSeek + Claude Code Loop

Run [Claude Code](https://github.com/anthropics/claude-code) backed by **DeepSeek V4 Pro** via the Anthropic-compatible API, in autonomous loop mode.

## Prerequisites

- Node.js >= 22
- DeepSeek API key ([get one here](https://platform.deepseek.com/api_keys))

## Quick Start

```bash
# Clone
git clone https://github.com/mgnlia/deepseek-claude-loop.git
cd deepseek-claude-loop

# Install and configure
./setup.sh

# Source env
source ~/.config/deepseek-claude-loop/env

# Run a task in a loop
./loop.sh "Fix all TypeScript errors in the project"
```

## How It Works

Claude Code is designed for Anthropic's API. DeepSeek exposes an Anthropic Messages API-compatible endpoint at `https://api.deepseek.com/anthropic`. By setting `ANTHROPIC_BASE_URL` and `ANTHROPIC_API_KEY`, Claude Code talks to DeepSeek instead.

The `loop.sh` script wraps Claude Code in a continuous loop:
1. Sends the task to Claude Code (running against DeepSeek V4 Pro)
2. Waits for completion
3. Continues the session with `--continue`
4. Repeats until stopped or max loops reached

## Usage

```bash
source ~/.config/deepseek-claude-loop/env

# Run until interrupted (Ctrl+C)
./loop.sh "Review all PRs and leave code review comments"

# Run with 5-minute intervals between loops
CLAUDE_LOOP_INTERVAL=300 ./loop.sh "Monitor production logs for errors"

# Run exactly 10 loops
CLAUDE_LOOP_MAX_LOOPS=10 ./loop.sh "Add unit tests for uncovered functions"
```

## Configuration

| Env Var | Default | Description |
|---|---|---|
| `ANTHROPIC_API_KEY` | (required) | DeepSeek API key |
| `ANTHROPIC_BASE_URL` | `https://api.deepseek.com/anthropic` | DeepSeek Anthropic-compatible endpoint |
| `CLAUDE_LOOP_MODEL` | `deepseek-v4-pro` | Model ID |
| `CLAUDE_LOOP_INTERVAL` | `0` | Seconds between iterations |
| `CLAUDE_LOOP_MAX_LOOPS` | unlimited | Max loop count |

## Available Models

| Model ID | Description |
|---|---|
| `deepseek-v4-pro` | DeepSeek V4 Pro (most capable) |
| `deepseek-v4-flash` | DeepSeek V4 Flash (fast, via `deepseek-chat`) |
| `deepseek-reasoner` | DeepSeek R1 reasoning |

## One-Liner Install

```bash
curl -fsSL https://raw.githubusercontent.com/mgnlia/deepseek-claude-loop/main/setup.sh | bash
```

## License

MIT
