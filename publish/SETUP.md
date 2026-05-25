# Setup

**Time: ~1 minute, two commands.** This is what you run *once* after `clawhub install ditto`.

## 1. Install the Ditto CLI

OpenClaw's Skills UI surfaces a one-click "**Install Ditto CLI (npm)**" button when this skill loads. Click it.

Manual equivalent:

```bash
npm install -g @heyditto/cli
```

Verify the binary is on `PATH`:

```bash
ditto --version
```

Use `@heyditto/cli` 1.2.0 or newer for the current `fetch --memory-format`,
`update`, and `publish` commands.

## 2. Create a claimable agent account

No human setup is required. Run:

```bash
ditto init --agent --agent-caller openclaw --json
```

That creates a free temporary agent account, writes the key to `~/.config/heyditto/cli/config.json` (mode 0600), and prints a short `claimURL` for later human ownership. Share the `claimURL`, not the `ditto_mcp_...` API key. The claim token is in the URL fragment (`#t=...`), and claiming keeps the same key and memories intact.

Already have a key? You can still run:

```bash
ditto login <paste-key>
```

> Prefer env vars? `export DITTO_API_KEY=ditto_mcp_…` works too — env always wins over the saved key.

## 3. Smoke test

```bash
ditto status
```

Should print:

```
@heyditto/cli 1.x.x
endpoint:  https://api.heyditto.ai/mcp
api key:   set  (source: config)
tools:     fetch_memories, get_memory_network, save_memory,
           list_memories, list_my_memories, publish_memory,
           search_memories, search_memories_in_subjects, search_subjects,
           unpublish_memory, update_memory
```

```bash
ditto subjects "test"
```

Should return JSON results from your account.

## You're done

OpenClaw will now use Ditto memory automatically when the conversation calls for it. See `examples.md` (or `ditto help`) for the full command reference.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `ditto: command not found` | Reopen your shell or run `which npm` to confirm the npm prefix is on `PATH`. |
| `Unknown option '--memory-format'` or `Unknown command: update/publish` | Update the CLI with `npm install -g @heyditto/cli@latest`. |
| `error: no Ditto API key configured` | Run `ditto init --agent --agent-caller openclaw --json` for no-human setup, or `ditto login <key>` if you already have a key. |
| `ditto status` shows `source: env` but you wanted `config` | The env var overrides. Run `unset DITTO_API_KEY` (and remove from `~/.zshrc` / `~/.bashrc` if persisted). |
| Connection failures | Verify the key with `ditto status`; rotate via `ditto logout && ditto login <new-key>`. |

## Where to get help

- **Skill issues:** https://github.com/ditto-assistant/ditto-clawhub/issues
- **CLI issues:** https://github.com/ditto-assistant/ditto-cli/issues
- **Account / backend:** **support@heyditto.ai**
- **CLI on npm:** https://www.npmjs.com/package/@heyditto/cli
