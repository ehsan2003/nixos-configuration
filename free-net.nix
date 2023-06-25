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

  systemd.services.proxy = {
    enable = true;
    description = "main proxy for system";
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "/etc/proxy/main.sh";
    };
    path = with pkgs; [ clash xray unstable.sing-box ];
    wantedBy = [ "multi-user.target" ];
  };

  environment.shellAliases.sp = "export HTTPS_PROXY=socks5://localhost:1080;";
  environment.shellAliases.ssp = "sudo HTTPS_PROXY=socks5://localhost:1080 -s";

  environment.systemPackages = with pkgs; [
    clash
    openvpn
    xray
    v2ray
    unstable.clash-verge
    unstable.clash-meta
    unstable.sing-box
  ];
}
