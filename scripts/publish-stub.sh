#!/usr/bin/env bash
set -euo pipefail

# Claim or refresh the `ditto` slug on ClawHub with the SKILL.md only.
# Run this BEFORE the real CLI is wired up, to hold the slug.
#
# Prereqs:
#   - npm i -g clawhub
#   - clawhub login   (GitHub OAuth, opens browser)

VERSION="${1:-0.0.1}"
CHANGELOG="${2:-Reserve slug for upcoming Ditto skill}"

echo "Publishing stub Ditto skill v$VERSION to ClawHub…"
clawhub skill publish . \
  --slug ditto \
  --name "Ditto" \
  --version "$VERSION" \
  --tags latest \
  --changelog "$CHANGELOG"
