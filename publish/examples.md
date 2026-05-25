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

## Pattern 4 — correct an existing memory

Fetch an outline to get stable block IDs. For precise edits, use the current revision from a prior `save` or `update` response; otherwise use full replacement.

```bash
# targeted edit
ditto fetch <pairId> --memory-format outline
ditto update <pairId> \
  --edits-json '[{"op":"replace_text","blockId":"2","find":"old","replace":"new","expectedCount":1}]' \
  --base-revision <revision>

# full replacement when the revision is unknown
ditto update <pairId> --content-file revised.md
```

## Pattern 5 — publish only on explicit request

```bash
ditto publish <pairId> --title "<optional title>" --privacy-mode scan_and_block
ditto unpublish --share-id <shareId>
```

## Pattern 6 — "show me everything related to X"

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
| `ditto search <q>...` | one or more queries | `--include-public`, `--filter-username <u>` |
| `ditto fetch <id>...` | one or more pair/share ids | `--memory-format full\|outline\|blocks` |
| `ditto list` | — | `--username <u>`, `--limit <n>`, `--offset <n>`, `--source <s>` |
| `ditto update <id>` | memory id plus content or edits | `--content`, `--content-file`, `--edits-json`, `--edits-file`, `--base-revision`, `--title` |
| `ditto publish <id>` | memory id | `--title <t>`, `--privacy-mode <mode>` |
| `ditto unpublish` | one id | `--memory-id <id>`, `--share-id <id>` |
| `ditto subjects <q>` | query | `--top-k <n>` (default 10, max 100) |
| `ditto memories <id>...` | one or more subject ids | `--query <q>` |
| `ditto network <id>` | pair id | `--limit <n>` (default 20, max 50) |

## Pattern 7 — first-run, no key configured

If `ditto status` reports `MISSING (source: none)` or any command exits with `error: no Ditto API key configured`:

1. Tell the user: "Get a key at **https://app.heyditto.ai/connect/openclaw** and paste it here."
2. When the user pastes a `ditto_mcp_…` key, run **one** command:
   ```bash
   ditto login <key>
   ```
3. Confirm with `ditto status` (should show `source: config`), then retry the original command.

Do **not** ask the user to edit `~/.zshrc` or set env vars. `ditto login` persists across shells without that step.

## When something fails

- **`error: no Ditto API key configured`** → see Pattern 5 above. Run `ditto login <key>`.
- **Connection failed** → check `ditto status`; rotate via `ditto logout && ditto login <new-key>`.
- **Empty results** → user may not have memories matching the query. Suggest they save the fact with `ditto save`.
- **Unknown `--memory-format` or `update`/`publish` command** → update the CLI with `npm install -g @heyditto/cli@latest`.
- **Schema mismatch** → run `ditto status` to see live tool names; consult `ditto help` for current flags.
- **Anything else** → support@heyditto.ai
