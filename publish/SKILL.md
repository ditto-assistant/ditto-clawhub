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
            "bins": ["mcporter"],
            "env": ["DITTO_API_KEY"],
          },
        "install":
          [
            {
              "id": "node",
              "kind": "node",
              "package": "mcporter",
              "bins": ["mcporter"],
              "label": "Install mcporter (node)",
            },
          ],
      },
  }
---

# Ditto

Ditto is a personal-memory assistant. These tools save, search, and traverse the user's long-term memory and topic graph at https://heyditto.ai.

The skill is wired through `mcporter`, which is already part of the openclaw stack. No Ditto-specific binary is needed.

## When to use

Reach for Ditto memory whenever the user:

- Says "remember…", "save this", "note that…", "for later".
- Says "what did I…", "recall…", "have I told you about…", "from my notes".
- Asks a question best answered from their prior context, not general knowledge.
- References a topic, person, project, or thread that isn't in this conversation but might be in their memory.

## One-time setup (the user does this once)

1. Open https://app.heyditto.ai/mcp/newkey, click **New key**, copy the value.
2. Export it to your shell:

   ```bash
   export DITTO_API_KEY=ditto_mcp_…
   # add to ~/.zshrc or ~/.bashrc to persist
   ```

3. Register the Ditto MCP server with mcporter (writes to `~/.mcporter/mcporter.json`):

   ```bash
   mcporter config add ditto \
     --http-url https://api.heyditto.ai/mcp \
     --header "Authorization=Bearer ${DITTO_API_KEY}"
   ```

After that, `mcporter call ditto.<tool>` works from anywhere.

If `mcporter config add` is unavailable, paste this into `~/.mcporter/mcporter.json`:

```json
{
  "mcpServers": {
    "ditto": {
      "url": "https://api.heyditto.ai/mcp",
      "headers": {
        "Authorization": "Bearer ${DITTO_API_KEY}"
      }
    }
  }
}
```

## Tools

Memories are **pairs** (one User turn + one Ditto turn) identified by a `pair_id`. **Subjects** are graph nodes for topics, identified by `subject_id`. Always pass arguments using JSON via `--args` for arrays — flag-style does not coerce arrays correctly.

### `save_memory`

Persist a memory pair from an external source. Use for explicit save requests, and proactively for durable preferences, decisions, relationships, or facts.

```bash
mcporter call ditto.save_memory --args '{
  "content": "User prefers TypeScript over JavaScript for new projects.",
  "source": "openclaw",
  "sourceContext": "preferences-discussion"
}'
```

Args: `content` (required), `source` (default `"mcp"`; pass `"cursor"`, `"document"`, `"note"`, `"openclaw"` etc.), `sourceContext` (file path / URL / project name).

### `search_memories`

Semantic search across the user's memories with learned retrieval weights. Accepts an **array** of queries — pass multiple to broaden recall. Returns lightweight previews ranked by composite score.

```bash
mcporter call ditto.search_memories --args '{
  "queries": ["typescript preferences", "language choices"]
}'
```

Use `fetch_memories` afterwards if you need the full conversation text.

### `fetch_memories`

Fetch the full conversation text (User + Ditto turns) for memory pairs by id. Use after `search_memories` returns previews.

```bash
mcporter call ditto.fetch_memories --args '{
  "pairIds": ["3a1084ae-235a-433d-9493-2335a0dfeb57"]
}'
```

### `search_subjects`

Search the subject graph. Returns subject IDs you can feed into `search_memories_in_subjects`. Default `topK` is 10, max 100.

```bash
mcporter call ditto.search_subjects --args '{
  "query": "memory architecture",
  "topK": 5
}'
```

### `search_memories_in_subjects`

Get memory previews scoped to specific subjects. Use after `search_subjects` when you want depth on a known topic instead of broad semantic search.

```bash
mcporter call ditto.search_memories_in_subjects --args '{
  "subjectIds": ["3a1084ae-235a-433d-9493-2335a0dfeb57"]
}'
```

### `get_memory_network`

Traverse a memory's network — related memories connected via shared subjects. Default `limit` is 20, max 50. Use for "show me everything connected to X" prompts.

```bash
mcporter call ditto.get_memory_network --args '{
  "pairId": "3a1084ae-235a-433d-9493-2335a0dfeb57",
  "limit": 20
}'
```

## Output

Append `--output json` to any call for machine-readable results, `--output markdown` for rendered output. Defaults to `text`.

## Authoritative reference

`mcporter list ditto --schema` prints the live tool schemas straight from the MCP — trust it over this file if anything drifts.

## Source

- Skill repo: https://github.com/ditto-assistant/ditto-clawhub
- Backend MCP: `https://api.heyditto.ai/mcp` (auth: `Authorization: Bearer ${DITTO_API_KEY}`)
- Get a key: https://app.heyditto.ai/mcp/newkey
