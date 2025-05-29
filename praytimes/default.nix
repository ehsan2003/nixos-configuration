{ pkgs, config, fenix, unstable, ... }:
let
  adhanFile = ./adhan.mp3;
  playAdhan = "${pkgs.vlc}/bin/vlc ${adhanFile}";
  configFile = pkgs.writeTextFile {
    name = "praytimes.json";
    destination = "/etc/praytimes/praytimes.json";
    text = builtins.toJSON {
      location = with config.location; {
        inherit latitude;
        inherit longitude;
      };
      parameters = { method = "Tehran"; };
      commands = [
        {
          praytime = "dhuhr";
          time_diff = 300;
          cmd = ''
            notify-send adhan "its time for dhuhr prayer ( it was at $TIME )"
            task add tag:chore namaz due:1hrs
          '';
        }
        {
          praytime = "dhuhr";
          time_diff = 0;
          cmd = playAdhan;
        }
        {
          praytime = "maghrib";
          time_diff = 300;
          cmd = ''
            notify-send adhan "Its time for maghrib prayer (it was at $TIME )"
            task add tag:chore namaz due:1hrs
          '';
        }
        {
          praytime = "maghrib";
          time_diff = 0;
          cmd = playAdhan;
        }
        {
          praytime = "sunset";
          time_diff = -480;
          cmd =
            ''notify-send sunset "Its nearly sunset expect it on ($TIME) "'';
        }
        {
          praytime = "midnight";
          time_diff = -480;
          cmd = ''
            notify-send midnight "Its nearly midnight expect it on ($TIME) "'';
        }
      ];

    };
  };
in {

  nixpkgs.config.packageOverrides = pkgs: {
    praytimes-config = configFile;

    praytimes-kit = ((pkgs.makeRustPlatform {
      inherit (fenix.packages.x86_64-linux.stable) cargo rustc;
    }).buildRustPackage {
      pname = "praytimes-kit";
      version = "1.1.0";

      src = pkgs.fetchFromGitHub {
        owner = "basemax";
        repo = "praytimesrust";
        rev = "1fc8e65679736b422b614f3470b0a97f6df5053a";
        sha256 = "sha256-mi3RS+7cv5mTLxMkJtOFd6OtVAxFLt1LkhsKgTYlLmM=";
      };

      cargoHash = "sha256-VURaHe07+9RMCUXK1PkP60jIpnJDS0ZLyViyrIZ0/1o=";

      meta = with pkgs.lib; {
        description = "A rust based praytimes calculator";
        homepage = "https://github.com/basemax/praytimesrust";
        license = licenses.gpl3;
      };
    });
  };
  systemd.user.services.praytimes = {
    enable = true;
    description = "praytimes";
    environment = {
      PRAYTIMES_LOG = "info";
      DISPLAY = ":0";
    };
    path =
      [ pkgs.bashInteractive pkgs.libnotify pkgs.dbus pkgs.taskwarrior3 ];
    wantedBy = [ "default.target" ];
    restartTriggers = [ configFile ];
    serviceConfig = {
      Restart = "always";
      ExecStart =
        "${pkgs.praytimes-kit}/bin/praytimes-kit daemon ${configFile}/etc/praytimes/praytimes.json";
    };
  };
  environment.systemPackages = with pkgs; [ praytimes-kit ];

  environment.shellAliases.pt =
    "${pkgs.praytimes-kit}/bin/praytimes-kit calculate --config  ${configFile}/etc/praytimes/praytimes.json";

  environment.shellAliases.pn =
    "${pkgs.praytimes-kit}/bin/praytimes-kit next --config  ${configFile}/etc/praytimes/praytimes.json";
}
