#!/usr/bin/env bash
set -euo pipefail

# Publish the Ditto skill bundle from ./publish to ClawHub.
# Usage:  ./scripts/publish.sh <semver> [<changelog>]
#
# Prereqs:
#   npm i -g clawhub
#   clawhub login                       # GitHub OAuth, opens browser
#   clawhub whoami                      # confirm identity that owns the slug

VERSION="${1:?usage: publish.sh <semver> [changelog]}"
CHANGELOG="${2:-Release v$VERSION}"

cd "$(dirname "$0")/.."

if [[ ! -f publish/SKILL.md ]]; then
  echo "error: publish/SKILL.md not found." >&2
  exit 1
fi

echo "Publishing Ditto skill v$VERSION to ClawHub from ./publish…"
clawhub skill publish ./publish \
  --slug ditto \
  --name "Ditto" \
  --owner ditto \
  --version "$VERSION" \
  --tags latest \
  --changelog "$CHANGELOG"
