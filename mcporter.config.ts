// mcporter config for the Ditto skill CLI.
//
// Points mcporter at the production Ditto MCP and authenticates via API key.
// The user's DITTO_API_KEY is created at https://app.heyditto.ai/mcp/newkey.
//
// Build with: `just build` or `bun run build`
// Smoke test:  `bunx mcporter list ditto` / `bunx mcporter call ditto.<tool>`

export default {
  servers: {
    ditto: {
      url: "https://api.heyditto.ai/mcp",
      headers: {
        "X-API-Key": "${DITTO_API_KEY}",
      },
    },
  },
}
