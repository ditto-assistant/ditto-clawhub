# Setup

**Time: ~1 minute.** This is what you run *once* after `clawhub install ditto`.

## 1. Install the Ditto CLI

OpenClaw's Skills UI surfaces a one-click "**Install Ditto CLI (npm)**" button when this skill loads. Click it.

Manual equivalent:

```bash
npm install -g @heyditto/cli
```

Verify the binary is on `PATH`:

```bash
ditto --version
# → 1.0.0 (or later)
```

## 2. Get a Ditto API key

Go to **https://app.heyditto.ai/mcp/newkey**.

The page does one thing: signs you in (GitHub / Google / email) and creates an MCP API key with a copy button. The key looks like `ditto_mcp_…`.

## 3. Export the key

```bash
export DITTO_API_KEY=ditto_mcp_…
```

Add that line to `~/.zshrc` (or `~/.bashrc` / `~/.profile`) so it persists across shells.

## 4. Smoke test

```bash
ditto status
# → @heyditto/cli 1.0.0
#   endpoint:  https://api.heyditto.ai/mcp
#   api key:   set
#   tools:     fetch_memories, get_memory_network, save_memory,
#              search_memories, search_memories_in_subjects, search_subjects

ditto subjects "test"
# → JSON results from your account
```

If you see `error: DITTO_API_KEY is not set`, the env var didn't make it into your shell. Re-source your rc file or open a fresh terminal.

## You're done

OpenClaw will now use Ditto memory automatically when the conversation calls for it. See `examples.md` (or `ditto help`) for the full command reference.

## Where to get help

- **Skill issues:** https://github.com/ditto-assistant/ditto-clawhub/issues
- **CLI issues:** https://github.com/ditto-assistant/ditto-cli/issues
- **Account / backend:** support@heyditto.ai
- **CLI on npm:** https://www.npmjs.com/package/@heyditto/cli
