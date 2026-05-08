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
            "env": ["DITTO_API_KEY"],
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

The skill ships a single binary (`ditto`, from [`@heyditto/cli`](https://www.npmjs.com/package/@heyditto/cli)) that the agent shells out to. No mcporter required.

## When to use

Reach for Ditto memory whenever the user:

- Says "remember…", "save this", "note that…", "for later".
- Says "what did I…", "recall…", "have I told you about…", "from my notes".
- Asks a question best answered from their prior context, not general knowledge.
- References a topic, person, project, or thread that isn't in this conversation but might be in their memory.

## One-time setup (the user does this once)

1. **Install the CLI** — openclaw will show a one-click button labeled "Install Ditto CLI (npm)" the first time the skill loads. That runs `npm install -g @heyditto/cli`.
2. **Get an API key** at https://app.heyditto.ai/mcp/newkey (one-page flow, copy the key).
3. **Export it** in their shell:

   ```bash
   export DITTO_API_KEY=ditto_mcp_…
   # add to ~/.zshrc or ~/.bashrc to persist
   ```

4. **Verify** with `ditto status` — should print the endpoint, "api key: set", and the 6 tool names.

## Tools

Memories are **pairs** (one User turn + one Ditto turn) identified by a `pair_id`. **Subjects** are graph nodes for topics, identified by `subject_id`.

### `ditto save <content> [--source <s>] [--source-context <c>]`

Persist a memory pair from an external source. Use for explicit save requests, and proactively for durable preferences, decisions, relationships, or facts. `--source` defaults to `"cli"`; pass `"openclaw"`, `"document"`, `"note"`, etc. when relevant. `--source-context` can hold a file path, URL, or project name.

```bash
ditto save "User prefers TypeScript over JavaScript for new projects." --source openclaw
```

### `ditto search <query>...`

Semantic search across the user's memories with learned retrieval weights. **Multiple positional args become an array of queries** — pass several to broaden recall. Returns lightweight previews ranked by composite score.

```bash
ditto search "typescript preferences"
ditto search "typescript" "language choices"
```

Use `ditto fetch` afterwards if you need the full conversation text.

### `ditto fetch <pair-id>...`

Fetch the full conversation text (User + Ditto turns) for memory pairs by id. Use after `ditto search` returns previews.

```bash
ditto fetch 3a1084ae-235a-433d-9493-2335a0dfeb57
```

### `ditto subjects <query> [--top-k <n>]`

Search the subject graph. Returns subject IDs you can feed into `ditto memories`. Default `top-k` is 10, max 100.

```bash
ditto subjects "memory architecture" --top-k 5
```

### `ditto memories <subject-id>...`

Get memory previews scoped to specific subjects. Use after `ditto subjects` when you want depth on a known topic instead of broad semantic search.

```bash
ditto memories 3a1084ae-235a-433d-9493-2335a0dfeb57
```

### `ditto network <pair-id> [--limit <n>]`

Traverse a memory's network — related memories connected via shared subjects. Default `limit` is 20, max 50. Use for "show me everything connected to X" prompts.

```bash
ditto network 3a1084ae-235a-433d-9493-2335a0dfeb57 --limit 30
```

## Output

All commands emit JSON by default — pipe through `jq` for shaping. `ditto config` prints a Claude/Cursor-compatible MCP config snippet.

## Authoritative reference

`ditto status` prints the live tool list straight from the MCP — trust it over this file if anything drifts.

## Source

- CLI: https://www.npmjs.com/package/@heyditto/cli (`npm i -g @heyditto/cli`)
- Skill repo: https://github.com/ditto-assistant/ditto-clawhub
- CLI repo: https://github.com/ditto-assistant/ditto-cli
- Get a key: https://app.heyditto.ai/mcp/newkey
