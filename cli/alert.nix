pkgs: secrets:
pkgs.writeShellApplication {
  name = "al";
  runtimeInputs = [
    pkgs.curl
    pkgs.jq
  ];
  text = ''
    # Configuration
    API_URL="https://api.telegram.org/bot${secrets.NOTIFIER_BOT_TOKEN}"
    CHAT_ID="${secrets.CHAT_ID}"
    MAX_TEXT_LENGTH=4000
    PROXY="http://localhost:1080"

    # Function to send text message
    send_message() {
      local text;
      text="$1"
      export https_proxy=$PROXY
      curl -s -X POST "$API_URL/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$text" \
        -d parse_mode="markdown"
    }

    # Function to send document
    send_document() {
      local file_path;
      file_path="$1"
      local caption;
      caption="$2"
      export https_proxy=$PROXY

      curl -s -X POST "$API_URL/sendDocument" \
        -F chat_id="$CHAT_ID" \
        -F document="@$file_path" \
        -F caption="$caption" \
        -F parse_mode="markdown"
    }

    # Function to handle large text by splitting or sending as file
    handle_large_text() {
      local text;
      text="$1"
      local filename;
      filename="$2"

      if [ ''${#text} -le $MAX_TEXT_LENGTH ]; then
        send_message "$text"
      else
        # For very large text, save to temp file and send as document
        local temp_file;
        temp_file=$(mktemp)
        echo "$text" > "$temp_file"

        local caption;
        caption="Large message (length: ''${#text} chars)"
        if [ -n "$filename" ]; then
          caption="$caption - Original: $filename"
        fi

        send_document "$temp_file" "$caption"
        rm -f "$temp_file"
      fi
    }

    # Function to read from stdin with error handling
    read_stdin() {
      if [ -t 0 ]; then
        echo "Error: No input on stdin. Pipe some text or use -h for help." >&2
        exit 1
      fi

      local input;
      input=$(cat)

      if [ -z "$input" ]; then
        echo "Error: Empty stdin input" >&2
        exit 1
      fi

      echo "$input"
    }

    # Main script logic
    case "''${1:-}" in
      -h|--help)
        echo "Usage: al [OPTIONS] [TEXT]"
        echo ""
        echo "Send alerts via Telegram. By default reads from stdin."
        echo "Automatically handles messages > 4000 chars by sending as file."
        echo ""
        echo "Options:"
        echo "  -h, --help     Show this help message"
        echo "  -f, --file     Send file as attachment"
        echo "  TEXT           Send text message directly"
        echo ""
        echo "Examples:"
        echo "  echo 'Hello' | al                   # Send from stdin (default)"
        echo "  cat log.txt | al                    # Send file content via stdin"
        echo "  al 'Direct message'                 # Send text directly"
        echo "  al -f document.pdf                  # Send file attachment"
        echo "  al -f document.pdf 'Custom caption' # Send file with caption"
        echo "  printf '%s' \"\$(cat large.txt)\" | al # Large content as file"
        exit 0
        ;;
      -f|--file)
        if [ -z "''${2:-}" ]; then
          echo "Error: File path required" >&2
          exit 1
        fi

        file_path="''${2}"
        if [ ! -f "$file_path" ]; then
          echo "Error: File not found: $file_path" >&2
          exit 1
        fi

        caption="''${3:-File: $(basename "$file_path")}"
        send_document "$file_path" "$caption"
        ;;
      "")
        # No arguments: read from stdin by default
        input=$(read_stdin)
        handle_large_text "$input" "stdin"
        ;;
      *)
        # Argument provided: treat as text message
        handle_large_text "$1" "text"
        ;;
    esac
  '';
}
