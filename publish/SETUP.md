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

## 2. Get a key + log in

Visit **https://app.heyditto.ai/mcp/newkey** — one-page sign-in (GitHub / Google / email), click **New key**, copy.

Then:

```bash
ditto login <paste-key>
```

That writes the key to `~/.config/heyditto/cli/config.json` (mode 0600). Persists across shells. Done.

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
           search_memories, search_memories_in_subjects, search_subjects
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
| `error: no Ditto API key configured` | Run `ditto login <key>` (key from https://app.heyditto.ai/mcp/newkey). |
| `ditto status` shows `source: env` but you wanted `config` | The env var overrides. Run `unset DITTO_API_KEY` (and remove from `~/.zshrc` / `~/.bashrc` if persisted). |
| Connection failures | Verify the key with `ditto status`; rotate via `ditto logout && ditto login <new-key>`. |

## Where to get help

- **Skill issues:** https://github.com/ditto-assistant/ditto-clawhub/issues
- **CLI issues:** https://github.com/ditto-assistant/ditto-cli/issues
- **Account / backend:** **support@heyditto.ai**
- **CLI on npm:** https://www.npmjs.com/package/@heyditto/cli
