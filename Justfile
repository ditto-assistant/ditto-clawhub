default:
    @just --list

# Compile per-platform CLI binaries from the live Ditto MCP via mcporter.
build:
    bash scripts/build-cli.sh

# Smoke-test the CLI against the configured MCP (requires DITTO_API_KEY).
dev:
    bunx mcporter list ditto

# Stub publish — claims/refreshes the `ditto` slug on ClawHub.
# Use this BEFORE the real CLI build is ready, just to hold the slug.
publish-stub:
    bash scripts/publish-stub.sh

# Real release. Bump version in package.json first.
# Usage: just publish 0.1.0
publish version:
    bash scripts/publish-release.sh {{version}}
