# ditto-clawhub

The Ditto skill for [ClawHub](https://clawhub.ai) / [OpenClaw](https://github.com/openclaw/openclaw) — the text-only bundle that lands in `~/openclaw/skills/ditto/` after `clawhub install ditto`.

> **Sibling repos:** the actual `ditto` CLI binary lives in [**`ditto-cli`**](https://github.com/ditto-assistant/ditto-cli) (published as [**`@heyditto/cli`**](https://www.npmjs.com/package/@heyditto/cli) on npm). This repo is just the skill bundle that teaches the OpenClaw agent how and when to invoke it.

## What gets uploaded to ClawHub

The `publish/` folder. Three text files, ~250 lines total:

```
publish/
├── SKILL.md       # frontmatter (install spec for @heyditto/cli) + agent decision guide
├── SETUP.md       # human-facing 2-step setup
└── examples.md    # worked agent patterns (search→fetch, save, traverse, first-run-no-key)
```

ClawHub strips non-text files at publish (50MB cap), so binaries can't ship in the skill folder. The canonical openclaw pattern (matching steipete's first-party `mcporter`, `clawhub`, `peekaboo` skills) is to declare an `install` spec that gives users a one-click install button — for us, that runs `npm install -g @heyditto/cli`.

## Architecture

```
OpenClaw user                                                    OpenClaw agent
  │                                                                  │
  ├─ clawhub install ditto                                           │
  │     extracts publish/ into ~/openclaw/skills/ditto               │
  │                                                                  │
  ├─ Skills UI shows "Install Ditto CLI (npm)" button ─┐             │
  │     one click → npm install -g @heyditto/cli       │             │
  │                                                    ▼             │
  │                                    ┌──────────────────┐          │
  │                                    │  heyditto binary │ ◀────────┤ heyditto save / search /
  ├─ "what did I say about X?"         │   on user's PATH │          │ fetch / subjects /
  │                                    └────────┬─────────┘          │ memories / network
  │     agent runs `heyditto status`            │                     │
  │     sees `source: none`                   │                     │
  │     self-provisions an agent account      │                     │
  │                                             │                    │
  ├─ agent runs `heyditto init --agent --agent-caller openclaw --json` │
  │     creates a free claimable account and stores the API key      │
  │                                                                  │
  ├─ output includes a claimURL for later human ownership             │
  │                                             │                    │
  │     optional fallback: `heyditto login <key>` ─▶│                    │
  │     key persisted to ~/.config/heyditto/cli/config.json (0600)   │
  │                                             │                    │
  └─ retries the original ask                  ▼                     │
                                       Authorization: Bearer …       │
                                       https://api.heyditto.ai/mcp ──┘
```

Auth is API key. Agents can self-provision with `heyditto init --agent --json`; they share the short `claimURL` with users and keep the `ditto_mcp_...` key local. The claim token lives in the link's `?t=...` query parameter. `DITTO_API_KEY` env wins as override; otherwise the file. No `.zshrc` editing required.

The browser-OAuth flow lives separately in [`ditto-mcp`](https://github.com/ditto-assistant/ditto-mcp) (`@heyditto/mcp` on npm) for Claude Desktop / Cursor.

## Status

- [x] `@heyditto/cli` published on npm (1.2.x current skill target, [trusted publisher](https://docs.npmjs.com/trusted-publishers) via [`ditto-cli`](https://github.com/ditto-assistant/ditto-cli) GH Actions)
- [x] `publish/` bundle finalized — install spec points at `@heyditto/cli`, body teaches the `heyditto init --agent --json` flow on first-run-no-key
- [x] Cross-platform standalone binaries verified (`scripts/build-cli.sh`; forward-looking, not used by the skill)
- [ ] `ditto` slug claimed on ClawHub by `@ditto` org (drag `publish/` into clawhub.ai/publish)
- [ ] `https://app.heyditto.ai/connect/openclaw` live

## Layout

| Path | Purpose |
|---|---|
| `publish/SKILL.md` | ClawHub entrypoint. Frontmatter declares `install: { kind: node, package: "@heyditto/cli", bins: [heyditto] }` for the one-click button; body teaches the agent decision flow. |
| `publish/SETUP.md` | 2-step setup (`npm i -g @heyditto/cli` + `heyditto init --agent --json`). |
| `publish/examples.md` | Agent patterns: recall, opinion-search, save, network-traversal, first-run-no-key. |
| `config/mcporter.json` | Local mcporter config used only by `scripts/build-cli.sh`. Not part of the skill. |
| `scripts/build-cli.sh` | Optional: cross-compiles a standalone `ditto` binary for 5 platforms into `dist/`. Useful for direct distribution; **not** what users get via ClawHub. |
| `scripts/publish.sh` | `clawhub skill publish ./publish` wrapper for CLI-driven publishing. |
| `Justfile` | `just build`, `just dev`, `just publish <ver>`. |
| `dist/` (gitignored) | Output of `just build` — `ditto-{darwin,linux}-{arm64,x64}`, `ditto-windows-x64.exe`. |

## Publish

### Path A — drag into the form (current)

At https://clawhub.ai/publish, drag `publish/` into the dropzone with:

- **Slug** `ditto`
- **Display name** `Ditto`
- **Owner** `@ditto` org
- **Version** `1.0.0`
- **Tags** `latest`

The form preserves folder paths and flattens the outer wrapper automatically.

### Path B — `clawhub` CLI

Once `clawhub login` works for the `@ditto` org publisher:

```bash
clawhub login
just publish 1.0.0 "Initial release"
# wraps:  clawhub skill publish ./publish --slug ditto --name Ditto --owner ditto …
```

ClawHub publishes skill content as **MIT-0**. The source repo here is **MIT** to match other `ditto-assistant/*` repos.

## Build the standalone binary (optional)

Most OpenClaw users won't need this — they get `heyditto` via `npm install -g @heyditto/cli`. The standalone binaries are for users who don't want Node, or for direct GitHub Releases.

```bash
export DITTO_API_KEY=ditto_mcp_…   # mcporter connects at build time to embed schemas
just build                          # → dist/ditto-<platform> (5 binaries, ~60-110MB each)
```

First build per target downloads ~30MB of platform-specific Bun runtime; cached after.

## Related

- [`ditto-cli`](https://github.com/ditto-assistant/ditto-cli) — the source of `@heyditto/cli`. Where `heyditto login`, `heyditto save`, etc. are implemented.
- [`ditto-mcp`](https://github.com/ditto-assistant/ditto-mcp) — sibling stdio MCP bridge (`@heyditto/mcp`) with browser-OAuth, for Claude Desktop / Cursor.
- [openclaw/openclaw](https://github.com/openclaw/openclaw) — the assistant
- [openclaw/clawhub](https://github.com/openclaw/clawhub) — skill registry CLI + docs
- [openclaw/openclaw/skills/mcporter/SKILL.md](https://github.com/openclaw/openclaw/blob/main/skills/mcporter/SKILL.md) — canonical skill template we modeled after
