#!/usr/bin/env bash
set -euo pipefail

# Generate per-platform Ditto CLI binaries from the live MCP via mcporter.
# See https://github.com/openclaw/mcporter/blob/main/docs/cli-reference.md

bunx mcporter generate-cli \
  --command "https://api.heyditto.ai/mcp" \
  --name ditto \
  --bundle \
  --compile

echo
echo "Built: dist/ditto-*"
