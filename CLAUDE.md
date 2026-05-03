# DeepSeek Claude Loop

This repo contains scripts for running Claude Code against DeepSeek API in autonomous loop mode.

## Skill/Tool Restrictions

When running autonomously, be conservative:
- Prefer read-only operations when exploring
- Avoid destructive commands without explicit confirmation
- Do not access network resources (WebSearch, WebFetch) unless explicitly allowed
- Do not modify this repo's own scripts unless asked
