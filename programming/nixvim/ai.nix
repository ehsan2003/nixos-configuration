{ ... }:
let
in {
  plugins.avante = {
    enable = true;
    settings = {
      openai = {
        endpoint = "https://api.groq.com/openai/v1";
        max_tokens = 4096;
        api_key_name = "GROQ_API_KEY";
        model = "llama-3.3-70b-versatile";
        proxy = "socks5://localhost:1080";
        temperature = 0;
      };
      provider = "openai";
      diff = {
        autojump = true;
        debug = false;
        list_opener = "copen";
      };
      highlights = {
        diff = {
          current = "DiffText";
          incoming = "DiffAdd";
        };
      };
      hints = { enabled = true; };
      mappings = {
        diff = {
          both = "cb";
          next = "]x";
          none = "c0";
          ours = "co";
          prev = "[x";
          theirs = "ct";
        };
      };
      windows = {
        sidebar_header = {
          align = "center";
          rounded = true;
        };
        width = 30;
        wrap = true;
      };
    };
  };
}
