# Worked examples

End-to-end patterns the agent should follow when invoking Ditto from openclaw.

## Pattern 1 — "what did I say about X"

The user asks a recall question. Search memories, then fetch full bodies for the top hits.

```bash
# 1. broad semantic search
mcporter call ditto.search_memories --args '{"queries": ["X"]}'

# 2. fetch full text for the top hit(s)
mcporter call ditto.fetch_memories --args '{
  "pairIds": ["<pairId from step 1>"]
}'
```

Then summarize the fetched text for the user.

## Pattern 2 — "what do I think about X"

User wants opinions / preferences. Hit the subject graph first, then expand into memories on the matching subject.

```bash
# 1. find subjects matching the topic
mcporter call ditto.search_subjects --args '{"query": "X", "topK": 5}'

# 2. expand the strongest subject(s) into memories
mcporter call ditto.search_memories_in_subjects --args '{
  "subjectIds": ["<subjectId from step 1>"]
}'

# 3. optionally fetch full text for the most relevant memory
mcporter call ditto.fetch_memories --args '{"pairIds": ["<pairId>"]}'
```

## Pattern 3 — "remember this"

Explicit save request, or you spotted a durable fact worth keeping.

```bash
mcporter call ditto.save_memory --args '{
  "content": "<the durable fact in plain text, 1-3 sentences>",
  "source": "openclaw",
  "sourceContext": "<optional: project, file, channel>"
}'
```

Then confirm to the user: "Saved."

## Pattern 4 — "show me everything related to X"

Graph traversal — start from one memory, expand outward via shared subjects.

```bash
# 1. find the seed memory
mcporter call ditto.search_memories --args '{"queries": ["X"]}'

# 2. traverse its network
mcporter call ditto.get_memory_network --args '{
  "pairId": "<pairId from step 1>",
  "limit": 30
}'
```

## Common args reference

| Tool | Required | Optional |
|---|---|---|
| `save_memory` | `content` | `source`, `sourceContext` |
| `search_memories` | `queries` (array) | — |
| `fetch_memories` | `pairIds` (array) | — |
| `search_subjects` | `query` | `topK` (default 10, max 100) |
| `search_memories_in_subjects` | `subjectIds` (array) | — |
| `get_memory_network` | `pairId` | `limit` (default 20, max 50) |

## When something fails

- **`missing Authorization header`** → `DITTO_API_KEY` not exported, or mcporter config doesn't have the Bearer header. Re-run setup.
- **`Invalid session ID`** → Auth is fine but mcporter handshake skipped. Use `mcporter call ditto.<tool>` (which handles the handshake), not raw curl.
- **Empty results** → User may not have memories matching the query. Suggest they save the fact with `save_memory` if it's worth keeping.
- **Schema mismatch** → Run `mcporter list ditto --schema` to see the live MCP tool definitions and adjust args.
