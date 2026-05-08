# Setup

**Time: ~2 minutes.** This is what you run *once* after `clawhub install ditto`.

## 1. Install mcporter

If you haven't already (most openclaw users have it):

```bash
npm install -g mcporter
```

OpenClaw's Skills UI will surface a one-click "Install mcporter (node)" button when this skill loads — that runs the same command.

## 2. Get a Ditto API key

Go to **https://app.heyditto.ai/mcp/newkey**.

The page does one thing: signs you in (GitHub / Google / email) and creates an MCP API key with a copy button. The key looks like `ditto_mcp_…`.

## 3. Export the key

```bash
export DITTO_API_KEY=ditto_mcp_…
```

Add that line to `~/.zshrc` (or `~/.bashrc` / `~/.profile`) so it persists across shells.

## 4. Register Ditto with mcporter

```bash
mcporter config add ditto \
  --http-url https://api.heyditto.ai/mcp \
  --header "Authorization=Bearer ${DITTO_API_KEY}"
```

That writes to `~/.mcporter/mcporter.json`. After this, `mcporter call ditto.<tool>` works from any shell.

If `mcporter config add` doesn't accept those flags on your version, paste this into `~/.mcporter/mcporter.json` instead:

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

mcporter expands `${DITTO_API_KEY}` from your environment at call time.

## 5. Smoke test

```bash
mcporter list ditto
# → should print 6 tools: save_memory, search_memories, fetch_memories,
#                          search_subjects, search_memories_in_subjects,
#                          get_memory_network

mcporter call ditto.search_subjects --args '{"query": "test"}'
# → should return JSON results from your account
```

If you see `missing Authorization header`, the key isn't set or the header is missing. If you see `Invalid session ID`, auth is fine but you bypassed mcporter — make sure you used `mcporter call ditto.<tool>`, not raw curl.

## You're done

OpenClaw will now use Ditto memory automatically when the conversation calls for it. See `examples.md` (or `mcporter list ditto --schema`) for the full tool reference.

## Where to get help

- **Issues with the skill itself:** https://github.com/ditto-assistant/ditto-clawhub/issues
- **Issues with the backend / your account:** support@heyditto.ai
- **mcporter docs:** https://github.com/openclaw/mcporter
