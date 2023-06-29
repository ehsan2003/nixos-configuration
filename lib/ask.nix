{ pkgs, ... }:
with pkgs;
writeShellApplication rec {
  name = "ask";
  runtimeInputs = [curl jq  ];
  text = ''
    data=$(echo "$@" | jq -R '{prompt:.,options:{}}')
    curl 'https://chatbot.theb.ai/api/chat-process' \
      -H 'content-type: application/json' \
      -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
      --data-raw "$data" \
      --compressed \
      --silent \
      | jq '.delta' --join-output 
  '';
}
