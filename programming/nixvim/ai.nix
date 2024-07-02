{ pkgs, ... }:
let
  ChatGPT-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "chatgpt";
    src = pkgs.fetchFromGitHub {
      owner = "ehsan2003";
      repo = "ChatGPT.nvim";
      rev = "08ca94dd9912713e5957cd417ab0899a086b4594";
      sha256 = "sha256-9foQ5CfxbhfiiFnN7PsKuFaxhD5G6JDHPIK12og/P6Y=";
    };
    dependencies = with pkgs.vimPlugins; [
      nui-nvim
      plenary-nvim
      telescope-nvim
    ];
  };
in {
  extraPlugins = [ ChatGPT-nvim ];
  extraConfigLua = ''
    require("chatgpt").setup({
      openai_params = {
        model = "llama3-70b-8192",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 4095,
        temperature = 0.2,
        top_p = 0.1,
        n = 1,
      },
     openai_edit_params = { 
       model = "llama3-70b-8192", 
       frequency_penalty = 0, 
       presence_penalty = 0, 
       temperature = 0, 
       top_p = 1, 
       n = 1, 
     }, 
     actions_paths={"${./ai-actions.json}"},
     extra_curl_params = {
       "-x", "socks5://localhost:1080"
     }
    })
  '';
}
