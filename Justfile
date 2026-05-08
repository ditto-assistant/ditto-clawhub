default:
    @just --list

# Cross-compile the standalone Ditto CLI binary for all 5 platforms into dist/.
# Requires DITTO_API_KEY in env (mcporter connects to the live MCP at build time).
build:
    bash scripts/build-cli.sh

# Smoke-test the live MCP via mcporter (DITTO_API_KEY required, ditto registered in mcporter config).
dev:
    bunx mcporter list ditto

# Publish ./publish to ClawHub as version <version>.
# Usage: just publish 1.0.0 ["optional changelog"]
publish version changelog="Release":
    bash scripts/publish.sh {{version}} {{changelog}}
