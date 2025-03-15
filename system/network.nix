{ pkgs, unstable, secrets, ... }:
let proxyFile = pkgs.writeShellScriptBin "start-proxy" secrets.proxy;

in {
  imports = [ ];
  networking.nameservers = [ "1.1.1.1" ];
  networking.networkmanager.enable = true;
  services.expressvpn.enable = true;

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
  home-manager.users.ehsan.home.file.nekorayRouting = {
    target = ".config/nekoray/config/routes/Default";
    text = builtins.toJSON {
      block_domain = "geosite:category-ads-all";
      custom = ''{"rules": []}'';
      def_outbound = "proxy";
      direct_dns = "localhost";
      direct_domain = ''
        regexp:^.+\.ir$
        geosite:category-ir'';
      direct_ip = "geoip:ir";
      dns_final_out = "proxy";
      dns_routing = true;
      domain_strategy = "IPIfNonMatch";
      outbound_domain_strategy = "PreferIPv4";
      remote_dns = "https://1.1.1.1/dns-query";
      sniffing_mode = 1;
      use_dns_object = false;
    };
  };

  environment.systemPackages = [
    pkgs.xray
    pkgs.v2ray
    unstable.sing-box
    unstable.v2raya
    unstable.tun2socks
    unstable.nekoray
    unstable.amnezia-vpn
    unstable.amneziawg-go
    unstable.amneziawg-tools
    pkgs.expressvpn

  ];
  services.dbus.packages = [ unstable.amnezia-vpn ];
  services.resolved.enable = true;

  systemd = {
    packages = [ unstable.amnezia-vpn ];
    services."AmneziaVPN".wantedBy = [ "multi-user.target" ];
    services.proxy = {
      enable = true;
      description = "main proxy for system";
      after = [ "network.target" ];
      serviceConfig = {
        Restart = "always";
        ExecStart = "${proxyFile}/bin/start-proxy";
      };
      path = [ unstable.xray unstable.sing-box unstable.v2raya ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
