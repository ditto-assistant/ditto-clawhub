#!/usr/bin/env bash
set -euo pipefail

# Build cross-platform Ditto CLI binaries via mcporter + bun.
#
# Step 1 — mcporter generate-cli connects to the live MCP at
#          https://api.heyditto.ai/mcp, embeds tool schemas, emits ./ditto.ts.
# Step 2 — `bun build --compile` cross-compiles ditto.ts for each target.
#
# Requires DITTO_API_KEY in env (source ./.env.local first if you have one).
# Bun downloads the target runtime per platform on first build (cached after).
#
# Outputs:
#   dist/ditto-darwin-arm64
#   dist/ditto-darwin-x64
#   dist/ditto-linux-arm64
#   dist/ditto-linux-x64
#   dist/ditto-windows-x64.exe

cd "$(dirname "$0")/.."

if [[ -z "${DITTO_API_KEY:-}" ]]; then
  echo "error: DITTO_API_KEY not set." >&2
  echo "       Get a key at https://app.heyditto.ai/connect/openclaw" >&2
  echo "       Then: export DITTO_API_KEY=ditto_mcp_..." >&2
  exit 1
fi

mkdir -p dist

echo "→ generate ditto.ts from live MCP..."
bunx mcporter generate-cli --server ditto

echo "→ install mcporter locally so bun can resolve the import..."
[[ -d node_modules/mcporter ]] || bun install --silent

declare -a TARGETS=(
  "bun-darwin-arm64:darwin-arm64"
  "bun-darwin-x64:darwin-x64"
  "bun-linux-arm64:linux-arm64"
  "bun-linux-x64:linux-x64"
  "bun-windows-x64:windows-x64.exe"
)

for entry in "${TARGETS[@]}"; do
  target="${entry%%:*}"
  suffix="${entry##*:}"
  out="dist/ditto-$suffix"
  echo "→ compile $out"
  bun build ./ditto.ts --compile --target="$target" --outfile="$out" >/dev/null
done

rm -f ditto.ts

echo
echo "Built:"
ls -lh dist/ditto-*
