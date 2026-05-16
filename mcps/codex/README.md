# Codex MCPS

## Docs

- [Codex MCP Docs](https://github.com/openai/codex/blob/main/codex-rs/config.md#mcp_servers)

## Codex Config

```toml
[mcp_servers.playwright]
command = "npx"
args = ["@playwright/mcp@latest"]
```

## Install Commands

### Playwright

[Docs](https://github.com/microsoft/playwright-mcp)

```bash
codex mcp add playwright npx "@playwright/mcp@latest"
```

### Github

- [Docs](https://github.com/github/github-mcp-server/blob/main/docs/installation-guides/install-codex.md)
