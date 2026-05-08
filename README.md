# ditto-clawhub

The Ditto skill for [ClawHub](https://clawhub.ai) / [OpenClaw](https://github.com/openclaw/openclaw).

This repo holds two artifacts:

1. **`publish/`** — the ClawHub-publishable skill bundle (text-only, drag-into-form). SKILL.md + supporting docs that teach openclaw how to call the Ditto MCP via the user's existing `mcporter` CLI. **This is what gets uploaded to ClawHub.**
2. **`dist/`** *(gitignored)* — cross-platform standalone Ditto CLI binaries (5 platforms, Bun-compiled from the live MCP via `mcporter generate-cli`). Forward-looking — useful if/when we publish a `ditto` npm package, or distribute via GitHub Releases.

> Tracking issue: [ditto-assistant/ditto-app#1212](https://github.com/ditto-assistant/ditto-app/issues/1212)

## Architecture

ClawHub strips non-text files at publish (skills are markdown + supporting `.md`, 50MB cap), so the binary is **not** in the skill bundle. Instead, the skill declares an `install` spec that gives openclaw users a one-click "Install mcporter (node)" button — matching the canonical pattern of steipete's first-party skills (`openclaw/openclaw/skills/mcporter`, `skills/clawhub`, `skills/peekaboo`).

```
OpenClaw user
  │
  ├─ clawhub install ditto    ── extracts publish/ into ~/openclaw/skills/ditto
  │
  ├─ Skills UI: "Install mcporter (node)" button   (one-click npm install)
  │
  ├─ open https://app.heyditto.ai/mcp/newkey       (one-page key creation)
  │     export DITTO_API_KEY=…
  │
  └─ mcporter config add ditto …                   (one command, one time)

OpenClaw agent
  └─ mcporter call ditto.<tool> …  ──▶  https://api.heyditto.ai/mcp  (Authorization: Bearer)
```

Auth is API key (`DITTO_API_KEY` env), not OAuth. The browser-OAuth flow lives in the private [`ditto-mcp`](https://github.com/ditto-assistant/ditto-mcp) repo for desktop/Claude.

## Status

- [x] mcporter build verified end-to-end against `api.heyditto.ai/mcp` (5-platform Bun-compiled binaries, 6 tools, live calls work)
- [x] `publish/` bundle ready to drag into the ClawHub publish form
- [ ] `ditto` slug claimed on ClawHub by `@ditto` org (manual; UI form upload)
- [ ] Onboarding URL `app.heyditto.ai/mcp/newkey` live ([ditto-app#1217](https://github.com/ditto-assistant/ditto-app/issues/1217))

## Layout

| Path | Purpose |
|---|---|
| `publish/SKILL.md` | ClawHub entrypoint — frontmatter declares `install` for mcporter, body teaches `mcporter call ditto.<tool>` patterns |
| `publish/SETUP.md` | Human-facing 5-step setup guide |
| `publish/examples.md` | Worked agent-facing examples (search→fetch, save, traverse) |
| `config/mcporter.json` | Local mcporter config used by `scripts/build-cli.sh` to talk to the live MCP |
| `Justfile` | `just build`, `just publish-stub`, `just publish <ver>` |
| `scripts/build-cli.sh` | mcporter generate-cli → bun build cross-compile → `dist/ditto-<platform>` |
| `dist/` (gitignored) | Cross-platform binaries: darwin-arm64, darwin-x64, linux-arm64, linux-x64, windows-x64.exe |

## Build

Prereqs: [Bun](https://bun.sh), `DITTO_API_KEY` exported (mcporter connects at build time to embed schemas).

```bash
just build      # cross-compile all 5 platforms into dist/
just dev        # mcporter list ditto (smoke test against live MCP)
```

First build downloads target Bun runtimes per platform (~30MB each, cached after).

## Publish (skill)

The current path is **drag-into-form**: at https://clawhub.ai/publish, drop `publish/` into the form (slug `ditto`, owner `@ditto` org, version `1.0.0`, tags `latest`).

CLI publish (when the org is set up for CLI auth):

```bash
clawhub login
clawhub skill publish ./publish \
  --slug ditto --name Ditto --owner ditto \
  --version 1.0.0 --tags latest --changelog "Initial release"
```

ClawHub publishes content as **MIT-0**. The source repo is **MIT** to match other `ditto-assistant/*` repos.

## Related

- [ditto-app#1212](https://github.com/ditto-assistant/ditto-app/issues/1212) — parent design issue
- [ditto-app#1217](https://github.com/ditto-assistant/ditto-app/issues/1217) — onboarding URL (`/mcp/newkey`)
- [openclaw/openclaw](https://github.com/openclaw/openclaw) — the assistant
- [openclaw/clawhub](https://github.com/openclaw/clawhub) — skill registry CLI + docs
- [openclaw/mcporter](https://github.com/openclaw/mcporter) — MCP runtime / CLI generator
- [openclaw/openclaw/skills/mcporter/SKILL.md](https://github.com/openclaw/openclaw/blob/main/skills/mcporter/SKILL.md) — canonical skill template we modeled after
