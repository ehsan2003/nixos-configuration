{ pkgs, unstable, secrets, ... }:
let proxyFile = pkgs.writeShellScriptBin "start-proxy" secrets.proxy;
in {
  imports = [ ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://localhost:1080";
  services.openvpn.servers = {
    vpn = {
      autoStart = false;
      config = secrets.openvpn;
      updateResolvConf = true;
    };
  };

  systemd.services.v2raya = {
    enable = true;
    description = "v2rayA gui client";
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${unstable.v2raya}/bin/v2rayA";
    };
    path = with pkgs; [ iptables bash ];
    wantedBy = [ "multi-user.target" ];

  };
  systemd.services.proxy = {
    enable = true;
    description = "main proxy for system";
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${proxyFile}/bin/start-proxy";
    };
    path = with pkgs; [ xray unstable.sing-box unstable.v2raya ];
    wantedBy = [ "multi-user.target" ];
  };

  programs.clash-verge.enable = true;
  programs.proxychains = {
    enable = true;
    proxies = {
      main = {
        type = "socks5";
        enable = true;
        host = "127.0.0.1";
        port = 1080;
      };
    };

  };

  environment.shellAliases.sp = "export https_proxy=http://localhost:1080;";
  environment.shellAliases.ssp = "sudo https_proxy=http://localhost:1080 -s";
  services.tor = {
    enable = true;
    client.enable = true;
    torsocks.enable = true;
  };
  environment.systemPackages = with pkgs; [
    openvpn
    xray
    v2ray
    unstable.sing-box
    unstable.v2raya
  ];
}
