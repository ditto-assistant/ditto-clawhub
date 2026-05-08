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

Ditto is a personal-memory assistant. These tools save, search, and traverse the user's long-term memory and topic graph at https://heyditto.ai.

The skill ships a single binary (`ditto`, from [`@heyditto/cli`](https://www.npmjs.com/package/@heyditto/cli)). Auth is via API key — stored in `~/.config/heyditto/cli/config.json` (preferred) or `DITTO_API_KEY` env (override).

## When to use

Reach for Ditto memory whenever the user:

- Says "remember…", "save this", "note that…", "for later".
- Says "what did I…", "recall…", "have I told you about…", "from my notes".
- Asks a question best answered from their prior context, not general knowledge.
- References a topic, person, project, or thread that isn't in this conversation but might be in their memory.

## Auth — the two paths

**Always check `ditto status` first.** It prints `api key: set (source: env|config)` or `MISSING (source: none)`.

### If the key is missing

Tell the user:

> Get a key at **https://app.heyditto.ai/mcp/newkey** (one-page sign-in + copy), then paste it back to me.

When the user pastes a key (looks like `ditto_mcp_…`), run **one** command:

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

Memories are **pairs** (one User turn + one Ditto turn) identified by a `pair_id`. **Subjects** are graph nodes for topics, identified by `subject_id`.

### `ditto save <content> [--source <s>] [--source-context <c>]`

Persist a memory pair from an external source. Use for explicit save requests, and proactively for durable preferences, decisions, relationships, or facts. `--source` defaults to `"cli"`; pass `"openclaw"`, `"document"`, `"note"`, etc. when relevant. `--source-context` can hold a file path, URL, or project name.

```bash
ditto save "User prefers TypeScript over JavaScript for new projects." --source openclaw
```

### `ditto search <query>...`

Semantic search across memories with learned retrieval weights. **Multiple positional args become an array of queries** — pass several to broaden recall. Returns lightweight previews ranked by composite score.

```bash
ditto search "typescript preferences"
ditto search "typescript" "language choices"
```

Use `ditto fetch` afterwards if you need full conversation text.

### `ditto fetch <pair-id>...`

Fetch the full conversation text (User + Ditto turns) for memory pair ids returned by `ditto search`.

```bash
ditto fetch 3a1084ae-235a-433d-9493-2335a0dfeb57
```

### `ditto subjects <query> [--top-k <n>]`

Search the subject graph. Returns subject IDs you can feed into `ditto memories`. Default `top-k` is 10, max 100.

```bash
ditto subjects "memory architecture" --top-k 5
```

### `ditto memories <subject-id>...`

Get memory previews scoped to specific subjects. Use after `ditto subjects` when you want depth on a known topic.

```bash
ditto memories 3a1084ae-235a-433d-9493-2335a0dfeb57
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
- **Get a key:** https://app.heyditto.ai/mcp/newkey
- **Account / backend support:** support@heyditto.ai
