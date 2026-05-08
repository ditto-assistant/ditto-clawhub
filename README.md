# ditto-clawhub

The Ditto skill for [ClawHub](https://clawhub.ai) / [OpenClaw](https://github.com/openclaw/openclaw).

Wraps the Ditto MCP (`https://api.heyditto.ai/mcp`) into a ClawHub-installable skill plus an mcporter-generated CLI binary, so OpenClaw users can `clawhub install ditto` and have Ditto memory tools available immediately.

> Tracking issue: [ditto-assistant/ditto-app#1212](https://github.com/ditto-assistant/ditto-app/issues/1212)

## Status

Private + WIP. Public + v0.1.0 once:

- [ ] `ditto` slug claimed on ClawHub (stub v0.0.1)
- [ ] mcporter build verified end-to-end against `api.heyditto.ai/mcp`
- [ ] Onboarding URL [`app.heyditto.ai/mcp/newkey`](https://app.heyditto.ai/mcp/newkey) live ([ditto-app#1217](https://github.com/ditto-assistant/ditto-app/issues/1217))

## Architecture

```
OpenClaw  →  ditto CLI (mcporter)  →  https://api.heyditto.ai/mcp  (X-API-Key)
                  ▲
                  │ first run, no DITTO_API_KEY
                  └── https://app.heyditto.ai/mcp/newkey
```

Auth: API key (`DITTO_API_KEY` env), not OAuth. The browser-OAuth flow lives in the private [ditto-mcp](https://github.com/ditto-assistant/ditto-mcp) repo for desktop/Claude.

## Layout

| Path | Purpose |
|---|---|
| `SKILL.md` | ClawHub entrypoint — frontmatter + agent instructions |
| `mcporter.config.ts` | Points mcporter at `api.heyditto.ai/mcp` with `X-API-Key` header |
| `Justfile` | `just build`, `just publish-stub`, `just publish` |
| `scripts/` | Build + publish shell helpers |
| `dist/` (gitignored) | mcporter-compiled per-platform CLI binaries |

## Commands

Prereqs: [Bun](https://bun.sh), [`clawhub` CLI](https://github.com/openclaw/clawhub) (`npm i -g clawhub`).

```bash
just build              # mcporter generate-cli --bundle --compile
just dev                # mcporter call ditto.<tool> ... (smoke test)
just publish-stub       # claim/refresh slug with current SKILL.md only
just publish 0.1.0      # publish a real release with the bundled CLI
```

## Publishing

1. **Slug claim (one-time, manual):** see [issue #1212 → "Claim the `ditto` slug"](https://github.com/ditto-assistant/ditto-app/issues/1212).
2. **Real releases:** bump version in `package.json`, run `just publish <version>`, and tag the commit.

ClawHub publishes content as **MIT-0**. The source repo is **MIT** to match other `ditto-assistant/*` repos.

## Related

- [ditto-app#1212](https://github.com/ditto-assistant/ditto-app/issues/1212) — parent design issue
- [ditto-app#1217](https://github.com/ditto-assistant/ditto-app/issues/1217) — onboarding URL (`/mcp/newkey`)
- [openclaw/mcporter](https://github.com/openclaw/mcporter) — MCP → CLI generator
- [openclaw/clawhub](https://github.com/openclaw/clawhub) — skill registry CLI + docs
