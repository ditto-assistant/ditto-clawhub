#!/usr/bin/env bash
set -euo pipefail

# Generate the Ditto CLI binary from the live MCP via mcporter.
# Requires DITTO_API_KEY in env (mcporter connects at build time to embed
# tool schemas). Source ./.env.local first if you have one.
# See https://github.com/openclaw/mcporter

bunx mcporter generate-cli \
  --server ditto \
  --compile ./dist/ditto

echo
echo "Built: ./dist/ditto"
