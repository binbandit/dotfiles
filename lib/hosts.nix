let
  defaults = {
    fish = {
      paths = [
        "~/Applications"
        "~/Applications/bin"
        "~/Library/Python/3.9/bin"
        "~/.local/bin"
        "~/.bin"
        "~/.cargo/bin"
        "~/.bun/bin"
        "~/.radicle/bin"
      ];

      env = {
        BUN_INSTALL = "~/.bun";
        OPENAI_MODEL = "gpt-5-nano";
        OPENAI_URL = "https://api.openai.com/v1/";
        OPENAI_TIMEOUT = "4096";
        OPENAI_MAX_TOKENS = "272000";
      };

      plugins = {
        fisherfile = [
          "jorgebucaran/fisher"
          "patrickf1/fzf.fish"
          "edc/bass"
          "laughedelic/pisces"
          "jorgebucaran/replay.fish"
          "vincentjames501/fish-kill-on-port"
        ];
      };

      proxies = {
        http = "";
        https = "";
        no_proxy = "";
      };
    };

    pnpm = {
      globalPackages = [ ];
    };

    mise = {
      tools = {
        bun = "latest";
        go = "latest";
        node = "25";
        pnpm = "latest";
        "npm:@openai/codex" = "latest";
        "npm:@anthropic-ai/claude-code" = "latest";
      };
    };

    uv = {
      pythonVersion = "3.12";
    };

    cargoTools = [
      {
        name = "tap";
        git = "https://github.com/crazywolf132/tap.git";
      }
      {
        name = "sg";
        git = "https://github.com/sage-scm/sage.git";
        bin = "sg";
      }
      {
        name = "keychainctl";
        git = "https://github.com/binbandit/keychainctl.git";
      }
    ];
  };

  hosts = {
    "Braydens-MacBook-Pro" = {
      roles = [ "personal" "mac" ];
      fish = {
        paths = [
          "~/.mitm_toolkit/bin"
        ];
        env = {
          OPENAI_MODEL = "gpt-5-nano";
        };
      };
    };

    "EPZ-D3YJQFV0WJ" = {
      roles = [ "work" "mac" ];
      fish = {
        env = {
          HTTP_PROXY = "http://localhost:3128";
          HTTPS_PROXY = "http://localhost:3128";
          ALL_PROXY = "http://localhost:3128";
          http_proxy = "http://localhost:3128";
          https_proxy = "http://localhost:3128";
          all_proxy = "http://localhost:3128";
          CUSTOM_CERT_BUNDLE_PATH = "/Users/Shared/ca_certs/bundle.pem";
          AWS_CA_BUNDLE = "/Users/Shared/ca_certs/bundle.pem";
          CLOUDSDK_AUTH_CORE_CUSTOM_CA_CERTS_FILE = "/Users/Shared/ca_certs/bundle.pem";
          CURL_CA_BUNDLE = "/Users/Shared/ca_certs/bundle.pem";
          GIT_SSL_CAINFO = "/Users/Shared/ca_certs/bundle.pem";
          NODE_EXTRA_CA_CERTS = "/Users/Shared/ca_certs/bundle.pem";
          PIP_CERT = "/Users/Shared/ca_certs/bundle.pem";
          REQUESTS_CA_BUNDLE = "/Users/Shared/ca_certs/bundle.pem";
          SSL_CERT_FILE = "/Users/Shared/ca_certs/bundle.pem";
        };
      };
    };

  };
in
{
  inherit defaults hosts;
}
