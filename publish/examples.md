# Worked examples

End-to-end patterns the agent should follow when invoking Ditto from openclaw.

## Pattern 1 — "what did I say about X"

The user asks a recall question. Search memories, then fetch full bodies for the top hits.

```bash
# 1. broad semantic search
ditto search "X"

# 2. fetch full text for the top hit(s)
ditto fetch <pairId from step 1>
```

Then summarize the fetched text for the user.

## Pattern 2 — "what do I think about X"

User wants opinions / preferences. Hit the subject graph first, then expand into memories on the matching subject.

```bash
# 1. find subjects matching the topic
ditto subjects "X" --top-k 5

# 2. expand the strongest subject(s) into memories
ditto memories <subjectId from step 1>

# 3. optionally fetch full text for the most relevant memory
ditto fetch <pairId>
```

## Pattern 3 — "remember this"

Explicit save request, or you spotted a durable fact worth keeping.

```bash
ditto save "<the durable fact in plain text, 1-3 sentences>" \
  --source openclaw \
  --source-context "<optional: project, file, channel>"
```

Then confirm to the user: "Saved."

## Pattern 4 — "show me everything related to X"

Graph traversal — start from one memory, expand outward via shared subjects.

```bash
# 1. find the seed memory
ditto search "X"

# 2. traverse its network
ditto network <pairId from step 1> --limit 30
```

## Common args reference

| Command | Required | Optional |
|---|---|---|
| `ditto save <content>` | content | `--source <s>`, `--source-context <c>` |
| `ditto search <q>...` | one or more queries | — |
| `ditto fetch <id>...` | one or more pair ids | — |
| `ditto subjects <q>` | query | `--top-k <n>` (default 10, max 100) |
| `ditto memories <id>...` | one or more subject ids | — |
| `ditto network <id>` | pair id | `--limit <n>` (default 20, max 50) |

## When something fails

- **`error: DITTO_API_KEY is not set`** → tell the user to visit https://app.heyditto.ai/mcp/newkey and export the key.
- **Connection failed** → check `ditto status` for the active endpoint; verify the key is the right one for that environment.
- **Empty results** → user may not have memories matching the query. Suggest they save the fact with `ditto save` if it's worth keeping.
- **Schema mismatch** → run `ditto status` to see live tool names; consult `ditto help` for current flags.
