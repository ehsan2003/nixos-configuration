{ ... }:
let
in {
  plugins.chatgpt = {
    enable = true;
    settings = {
      openai_params = {
        model = "llama3-70b-8192";
        frequency_penalty = 0;
        presence_penalty = 0;
        max_tokens = 4095;
        temperature = 0.2;
        top_p = 0.1;
        n = 1;
      };
      openai_edit_params = {
        model = "llama3-70b-8192";
        frequency_penalty = 0;
        presence_penalty = 0;
        temperature = 0;
        top_p = 1;
        n = 1;
      };
      extra_curl_params = [ "-x" "socks5://localhost:1080" ];
    };
  };

}
