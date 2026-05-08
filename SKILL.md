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
      Tools:
        save_memory                    Store a new memory
        search_memories                Semantic search across memories
        fetch_memories                 Fetch by id(s)
        search_subjects                Find topic clusters
        search_memories_in_subjects    Search within specific subjects
        get_memory_network             Traverse the memory graph
---

# Ditto

Ditto is a personal-memory assistant. These tools let you save, search, and traverse the user's long-term memory and topic graph.

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

### `ditto save_memory <text>`

Persist a memory. Use for explicit user requests to save, and proactively when the user shares durable preferences, decisions, relationships, or facts.

### `ditto search_memories <query> [--limit N]`

Semantic search across all of the user's memories. Use for "what did I say about X", "do I have anything on Y", or to ground an answer in their history.

### `ditto fetch_memories <id> [<id>…]`

Fetch full memory bodies by id, e.g. after `search_memories` returns matches.

### `ditto search_subjects <query>`

Search the topic/subject graph instead of individual memories — useful when you want clusters or themes rather than one-off facts.

### `ditto search_memories_in_subjects <subject> <query>`

Combine subject filtering with semantic search. Use when you know the topic but want a specific memory inside it.

### `ditto get_memory_network <subject>`

Traverse related subjects + memories for graph-style exploration ("show me everything connected to X").

## Notes

- Calls go to `https://api.heyditto.ai/mcp` over HTTPS with the `X-API-Key` header.
- The CLI is generated from the live MCP via [mcporter](https://github.com/openclaw/mcporter); the tool list above mirrors what `mcporter list ditto` reports at runtime.
- Source: https://github.com/ditto-assistant/ditto-clawhub
