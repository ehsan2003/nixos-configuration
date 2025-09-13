{ ... }:
let
in {
  plugins.avante = {
    enable = true;
    settings = {
      providers = {
        ossfast = {
          __inherited_from = "openai";
          endpoint = "https://openrouter.ai/api/v1";
          api_key_name = "OPENROUTER_API_KEY";
          model = "openai/gpt-oss-120b:nitro";
        };
        gpt5 = {
          __inherited_from = "openai";
          endpoint = "https://openrouter.ai/api/v1";
          api_key_name = "OPENROUTER_API_KEY";
          model = "openai/gpt-5";
        };
        groqoss = {
          __inherited_from = "openai";
          api_key_name = "GROQ_API_KEY";
          endpoint = "https://api.groq.com/openai/v1/";
          model = "openai/gpt-oss-120b";
          proxy = "socks5://localhost:1080";
          max_tokens = 4096;
          temperature = 0;
        };
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
