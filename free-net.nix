{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { };
in {
  imports = [ ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://localhost:1080";
  services.openvpn.servers = {
    vpn = {
      autoStart = false;
      config = "config /etc/openvpn/client.conf ";
      updateResolvConf = true;
    };
  };
  systemd.services.singbox = {
    enable = true;
    description = "sing box proxy stuff";
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart =
        "${unstable.sing-box}/bin/sing-box run -c /etc/singbox/config.json";
    };
    wantedBy = [ "multi-user.target" ];
  };
  programs.zsh.shellAliases.sp = "export HTTPS_PROXY=http://localhost:1080;";
  programs.zsh.shellAliases.ssp = "sudo HTTPS_PROXY=http://localhost:1080 -s";

  environment.systemPackages = with pkgs; [
    clash
    openvpn
    xray
    unstable.clash-verge
    unstable.clash-meta
    unstable.sing-box
  ];
}
