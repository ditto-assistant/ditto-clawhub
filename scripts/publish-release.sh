#!/usr/bin/env bash
set -euo pipefail

# Real release: bundle the CLI binary + SKILL.md and publish as a ClawHub package.
# Usage: ./scripts/publish-release.sh 0.1.0

VERSION="${1:?usage: publish-release.sh <semver>}"

if [[ ! -d dist ]]; then
  echo "error: dist/ not found — run 'just build' first." >&2
  exit 1
fi

echo "Publishing Ditto package v$VERSION to ClawHub…"
clawhub package publish . \
  --family code-plugin \
  --version "$VERSION" \
  --tags latest
