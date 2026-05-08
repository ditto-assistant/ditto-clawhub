---
name: ditto
description: |
  Ditto memory tools — save, search, fetch, and explore the user's personal memory graph.
  Use whenever the user references "remember", "recall", "what did I", "from my notes",
  or asks about past conversations and saved knowledge.
metadata:
  openclaw:
    requires:
      env:
        - DITTO_API_KEY
      bins:
        - ditto
    primaryEnv: DITTO_API_KEY
    cliHelp: |
      ditto --help
      Tools (kebab-case CLI; underlying MCP tools use snake_case):
        save-memory                    Store a new memory pair
        search-memories                Semantic search across memories
        fetch-memories                 Fetch full memory bodies by pair id
        search-subjects                Search the subject/topic graph
        search-memories-in-subjects    Memories scoped to specific subjects
        get-memory-network             Memory + related memories via shared subjects
---

# Ditto

Ditto is a personal-memory assistant. These tools save, search, and traverse the user's long-term memory and topic graph.

## When to use

- The user says "remember…", "save this", "note that…", "for later".
- The user says "what did I…", "recall…", "have I told you about…", "from my notes".
- A question is best answered from the user's prior context rather than general knowledge.
- The user references a topic, person, project, or thread that isn't in the current conversation but might be in their memory.

## Setup (first run)

If `DITTO_API_KEY` is missing, tell the user verbatim:

> Open https://app.heyditto.ai/mcp/newkey, click "New key", and paste it as `DITTO_API_KEY`. Then re-run.

That page does one thing: signs them in and creates an MCP API key with a copy button.

## Tools

Memories are stored as **pairs** (one User turn + one Ditto turn) identified by a `pair_id`. Subjects are graph nodes for topics, identified by `subject_id`.

### `ditto save-memory --content <text> [--source <kind>] [--source-context <ctx>]`

Persist a memory pair from an external source. Use for explicit user requests to save, and proactively when the user shares durable preferences, decisions, relationships, or facts. `--source` defaults to `mcp`; pass `cursor`, `document`, `note`, etc. when relevant. `--source-context` can hold a file path, URL, or project name.

### `ditto search-memories --queries <q1>,<q2>,…`

Semantic search across the user's memories using learned retrieval weights. Accepts an **array** of queries — pass multiple comma-separated to broaden recall. Returns lightweight previews ranked by composite score.

### `ditto fetch-memories --pair-ids <id1>,<id2>,…`

Fetch the full conversation text for memory pairs (User + Ditto turns) by id. Use after `search-memories` returns previews and you need full content.

### `ditto search-subjects --query <text> [--top-k <n>]`

Search the subject graph. Returns subject IDs you can feed into `search-memories-in-subjects`. Default `top-k` is 10, max 100.

### `ditto search-memories-in-subjects --subject-ids <id1>,<id2>,…`

Get memory previews scoped to specific subjects. Useful when you want depth on a known topic instead of broad semantic search.

### `ditto get-memory-network --pair-id <id> [--limit <n>]`

Traverse a memory's network — related memories connected via shared subjects. Default `limit` is 20, max 50. Use for "show me everything connected to X" prompts.

## Notes

- All calls go to `https://api.heyditto.ai/mcp` over HTTPS with `Authorization: Bearer ${DITTO_API_KEY}`.
- The CLI is generated from the live MCP via [mcporter](https://github.com/openclaw/mcporter). Tool schemas are embedded at build time — `ditto --help` and `ditto <tool> --help` are authoritative if anything here drifts.
- Source: https://github.com/ditto-assistant/ditto-clawhub
