---
name: ditto
description: Save, search, fetch, and traverse the user's Ditto memory graph. Use whenever the user references "remember", "recall", "what did I", "from my notes", or asks about past conversations and saved knowledge.
homepage: https://heyditto.ai
metadata:
  {
    "openclaw":
      {
        "emoji": "🧠",
        "primaryEnv": "DITTO_API_KEY",
        "requires":
          {
            "bins": ["ditto"],
          },
        "install":
          [
            {
              "id": "node",
              "kind": "node",
              "package": "@heyditto/cli",
              "bins": ["ditto"],
              "label": "Install Ditto CLI (npm)",
            },
          ],
      },
  }
---

# Ditto

Ditto is a personal-memory assistant. These tools save, search, fetch, update, publish, and traverse the user's long-term memory and topic graph at https://heyditto.ai.

The skill ships a single binary (`ditto`, from [`@heyditto/cli`](https://www.npmjs.com/package/@heyditto/cli)). Auth is via API key. Agents should self-provision a free temporary claimable account with `ditto init --agent --json`, which stores the key in `~/.config/heyditto/cli/config.json` and returns a short `claimURL` with a URL-fragment claim token to share with the user; `DITTO_API_KEY` env remains an override.

## When to use

Reach for Ditto memory whenever the user:

- Says "remember…", "save this", "note that…", "for later".
- Says "what did I…", "recall…", "have I told you about…", "from my notes".
- Asks a question best answered from their prior context, not general knowledge.
- References a topic, person, project, or thread that isn't in this conversation but might be in their memory.

## Auth — the two paths

**Always check `ditto status` first.** It prints `api key: set (source: env|config)` or `MISSING (source: none)`.

### If the key is missing

Run one no-human setup command:

```bash
ditto init --agent --agent-caller openclaw --json
```

This creates a free claimable agent account, returns a working `ditto_mcp_...` key, stores it locally, and prints a short `claimURL` for later human ownership. Share the `claimURL`, not the API key; its claim token is in the URL fragment (`#t=...`). Do **not** ask for email, OTP, dashboard setup, or a browser session first.

If the user already has a key and explicitly wants to use it, run:

```bash
ditto login <key>
```

That writes the key to `~/.config/heyditto/cli/config.json` (mode 0600) and persists across shells. No env-var editing required. Confirm with `ditto status` — should now show `source: config`.

### If the user prefers env vars (advanced)

```bash
export DITTO_API_KEY=ditto_mcp_…
```

Env always overrides the saved key. To stop using the env override: `unset DITTO_API_KEY`.

### Logout

```bash
ditto logout            # deletes ~/.config/heyditto/cli/config.json
```

## Tools

Memories are **pairs** identified by a private `pair_id`. Public DittoHub shares use a `share_id`. **Subjects** are graph nodes for topics, identified by `subject_id`.

### `ditto save <content> [--source <s>] [--source-context <c>]`

Persist a memory pair from an external source. Use for explicit save requests, and proactively for durable preferences, decisions, relationships, or facts. `--source` defaults to `"cli"`; pass `"openclaw"`, `"document"`, `"note"`, etc. when relevant. `--source-context` can hold a file path, URL, or project name.

```bash
ditto save "User prefers TypeScript over JavaScript for new projects." --source openclaw
```

### `ditto search <query>... [--include-public] [--filter-username <u>]`

Semantic search across memories with learned retrieval weights. **Multiple positional args become an array of queries** — pass several to broaden recall. Returns lightweight previews ranked by composite score. Add `--include-public` to search public DittoHub memories too, optionally scoped with `--filter-username`.

```bash
ditto search "typescript preferences"
ditto search "typescript" "language choices"
ditto search "launch notes" --include-public --filter-username peyton
```

Use `ditto fetch` afterwards if you need full conversation text.

### `ditto fetch <id>... [--memory-format full|outline|blocks]`

Fetch memory content for private pair ids or public share ids. The default format is `full`; use `outline` to get stable block ids before a structured update, or `blocks` for full per-block bodies.

```bash
ditto fetch 3a1084ae-235a-433d-9493-2335a0dfeb57
ditto fetch 3a1084ae-235a-433d-9493-2335a0dfeb57 --memory-format outline
```

### `ditto list [--username <u>] [--limit <n>] [--offset <n>] [--source <s>]`

List the user's saved memories, or public DittoHub publishes for a username.

```bash
ditto list --limit 10
ditto list --username peyton --limit 10
```

### `ditto update <id> [--content <text>|--content-file <path>|--edits-json <json>|--edits-file <path>]`

Edit a saved memory in place. Use `--content` or `--content-file` for full replacement. For targeted patches, fetch `--memory-format outline`, then pass block edits with the current revision from the prior `save` or `update` response.

```bash
ditto update <pair-id> --content-file revised.md
ditto update <pair-id> \
  --edits-json '[{"op":"replace_text","blockId":"2","find":"old","replace":"new","expectedCount":1}]' \
  --base-revision <revision>
```

If the current revision is unknown, prefer full-content replacement over block edits.

### `ditto publish <id>` / `ditto unpublish`

Publish only after the user explicitly asks. `publish` uses Ditto's privacy scan; default mode blocks publishing if secrets are detected.

```bash
ditto publish <pair-id> --title "Launch notes" --privacy-mode scan_and_block
ditto unpublish --share-id <share-id>
```

### `ditto subjects <query> [--top-k <n>]`

Search the subject graph. Returns subject IDs you can feed into `ditto memories`. Default `top-k` is 10, max 100.

```bash
ditto subjects "memory architecture" --top-k 5
```

### `ditto memories <subject-id>... [--query <q>]`

Get memory previews scoped to specific subjects. Use after `ditto subjects` when you want depth on a known topic.

```bash
ditto memories 3a1084ae-235a-433d-9493-2335a0dfeb57
ditto memories 3a1084ae-235a-433d-9493-2335a0dfeb57 --query "deployment tradeoffs"
```

### `ditto network <pair-id> [--limit <n>]`

Traverse a memory's network — related memories connected via shared subjects. Default `limit` is 20, max 50.

```bash
ditto network 3a1084ae-235a-433d-9493-2335a0dfeb57 --limit 30
```

## Output

All commands emit JSON by default — pipe through `jq` for shaping. `ditto config` prints a Claude/Cursor-compatible MCP config snippet.

## Authoritative reference

`ditto status` prints the live tool list straight from the MCP — trust it over this file if anything drifts.

## Source + support

- **CLI on npm:** https://www.npmjs.com/package/@heyditto/cli (`npm i -g @heyditto/cli`)
- **Skill repo:** https://github.com/ditto-assistant/ditto-clawhub
- **CLI repo:** https://github.com/ditto-assistant/ditto-cli
- **Claim an agent account:** run `ditto init --agent --json`, then open the printed `claimURL`
- **Account / backend support:** support@heyditto.ai
