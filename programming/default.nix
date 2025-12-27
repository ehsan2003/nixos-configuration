{ pkgs, fenix, unstable, secrets, ... }:
let aider-ce = unstable.callPackage ./aider-ce/package.nix { };
in {
  imports = [ ./editors.nix ./virtualisation.nix ];
  # git 
  home-manager.users.ehsan = {
    programs = {
      git = {
        enable = true;
        settings.user.name = "ehsan";
        settings.user.email = "ehsan2003.2003.382@gmail.com";
        settings.init = { defaultBranch = "main"; };
      };
    };
  };
  programs.git.config = { init = { defaultBranch = "main"; }; };

  nixpkgs.overlays = [ fenix.overlays.default ];

  environment.systemPackages = with pkgs; [
    unstable.pnpm
    unstable.nodejs_24
    python310
    git
    gcc
    unstable.bun
    unstable.playwright-mcp
    unstable.playwright-driver.browsers
    unstable.deno
    cloc
    postgresql_16
    lazygit
    typescript

    unstable.claude-code
    unstable.aider-chat # aider-ce
    unstable.vlang
    unstable.lazysql

    uv
    cargo-watch
    (pkgs.fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    pre-commit
  ];

  home-manager.users.ehsan.programs.claude-code = {
    enable = true;
    package = unstable.claude-code;
    settings = {
      env = {
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "glm-4.7";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "glm-4.7";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "glm-4.7";
        https_proxy = "http://localhost:1080";
        ANTHROPIC_AUTH_TOKEN = secrets.ANTHROPIC_AUTH_TOKEN;
        ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
      };
      hooks = {
        Notification = [
          {
            matcher = "*";
            hooks = [{
              type = "command";
              command = "notify-send 'Claude Code' 'Awaiting your input'";
            }];
          }
          {
            matcher = "*";
            hooks = [{
              type = "command";
              command = ''
                curl -s -X POST "https://api.telegram.org/bot${secrets.NOTIFIER_BOT_TOKEN}/sendMessage"  -d chat_id=${secrets.CHAT_ID}  -d text="claude is awaiting your input"'';
            }];
          }
        ];
      };
      alwaysThinkingEnabled = true;
    };
    mcpServers = {
      "web-search-prime" = {
        "type" = "http";
        "url" = "https://api.z.ai/api/mcp/web_search_prime/mcp";
        "headers" = {
          "Authorization" = "Bearer ${secrets.ANTHROPIC_AUTH_TOKEN}";
        };
      };

      "zai-mcp-server" = {
        "type" = "stdio";
        "command" = "npx";
        "args" = [ "-y" "@z_ai/mcp-server" ];
        "env" = {
          "Z_AI_API_KEY" = "${secrets.ANTHROPIC_AUTH_TOKEN}";
          "Z_AI_MODE" = "ZAI";
        };
      };
      "web-reader" = {
        "type" = "http";
        "url" = "https://api.z.ai/api/mcp/web_reader/mcp";
        "headers" = {
          "Authorization" = "Bearer ${secrets.ANTHROPIC_AUTH_TOKEN}";
        };
      };
      "zread" = {
        "type" = "http";
        "url" = "https://api.z.ai/api/mcp/zread/mcp";
        "headers" = {
          "Authorization" = "Bearer ${secrets.ANTHROPIC_AUTH_TOKEN}";
        };
      };
    };
  };
  services.postgresql.package = pkgs.postgresql_17;
  services.pgadmin.enable = true;
  services.pgadmin.initialEmail = "test@mail.com";
  services.pgadmin.initialPasswordFile = "/etc/pgadminpassword";

}
