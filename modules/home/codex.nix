{ lib, hostConfig, ... }:

let
  roles = hostConfig.roles or [ ];
  isWork = lib.elem "work" roles;

  personalConfig = lib.concatStringsSep "\n" [
    "model = \"gpt-5-codex\""
    "model_reasoning_effort = \"high\""
    ""
    "[mcp_servers.fetch]"
    "command = \"uvx\""
    "args = [\"mcp-server-fetch\"]"
    ""
    "[mcp_servers.linear]"
    "command = \"npx\""
    "args = [\"-y\", \"mcp-remote\", \"https://mcp.linear.app/sse\"]"
    ""
  ];

  workConfig = lib.concatStringsSep "\n" [
    "model = \"aipe-gpt-5_v2025-08-07_EASTUS2\""
    "model_provider = \"litellm\""
    ""
    "[model_providers.litellm]"
    "name = \"LiteLLM\""
    "base_url = \"https://api.studio.genai.cba\""
    "env_key = \"OPENAI_API_KEY\""
    "# network tuning overrides"
    "request_max_retries = 4"
    "stream_max_retries = 10"
    "stream_idle_timeout_ms = 300000"
    "http_headers = { \"x-tool\" = \"Roo Code\" }"
    ""
  ];
in
{
  home.file.".codex/config.toml".text = if isWork then workConfig else personalConfig;
}
