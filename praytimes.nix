{ pkgs, config, ... }:
let
  configFile = pkgs.writeTextFile {
    name = "praytimes.json";
    destination = "/etc/praytimes/praytimes.json";
    text = builtins.toJSON {
      location = with config.location ;{
        inherit latitude;
        inherit longitude;
      };
      parameters = { method = "Tehran"; };
      commands = [
        {
          praytime = "dhuhr";
          time_diff = 180;
          cmd = ''notify-send adhan "Its $TYPE at $TIME + $DIFF"'';
        }
        {
          praytime = "maghrib";
          time_diff = 180;
          cmd = ''
            notify-send adhan "Its $TYPE at $TIME + $DIFF the darkness is coming ..."'';
        }
        {
          praytime = "sunset";
          time_diff = -480;
          cmd = ''notify-send adhan "Its nearly $TYPE expect it on ($TIME) "'';
        }
        {
          praytime = "midnight";
          time_diff = -480;
          cmd = ''notify-send adhan "Its nearly $TYPE expect it on ($TIME) "'';
        }
      ];

    };
  };
in {

  nixpkgs.config.packageOverrides = pkgs: {
    praytimes-kit = (pkgs.rustPlatform.buildRustPackage {
      pname = "praytimes-kit";
      version = "1.0.0";

      src = pkgs.fetchFromGitHub {
        owner = "basemax";
        repo = "praytimesrust";
        rev = "2c3eb40c4d4bf7a3c3bf484e1a5400a8c4b9a381";
        sha256 = "sha256-qOKPXKERkWBePusM/YG9OoTmWHznSJUltYTWKTUJ9q8=";
      };

      cargoSha256 = "sha256-PWQc4VKxtxi7/PFvPLauTGwYF0DorFdFJzz0UsJY7GU=";

      meta = with pkgs.lib; {
        description = "A rust based praytimes calculator";
        homepage = "https://github.com/basemax/praytimesrust";
        license = licenses.gpl3;
      };
    });
  };
  systemd.services.praytimes = {
    enable = true;
    description = "praytimes";
    restartTriggers = [ configFile ];
    serviceConfig = {
      Restart = "always";
      ExecStart =
        "${pkgs.praytimes-kit}/bin/praytimes-kit daemon ${configFile}/etc/praytimes/praytimes.json";
    };
    wantedBy = [ "multi-user.target" ];
  };

  environment.shellAliases.pt =
    "${pkgs.praytimes-kit}/bin/praytimes-kit calculate --config  ${configFile}/etc/praytimes/praytimes.json";
}
