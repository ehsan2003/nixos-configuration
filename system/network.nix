{ pkgs, unstable, secrets, ... }:
let
  proxyFile = pkgs.writeShellScriptBin "start-proxy" secrets.proxy;
  awg-config = pkgs.writeTextFile {
    name = "awg-config";
    text = secrets.awg-config;
    destination = "/awg.conf";
  };
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

  systemd = {
    packages = [ unstable.amnezia-vpn ];
    services."AmneziaVPN".wantedBy = [ "multi-user.target" ];
    services.amnezia = {
      enable = true;
      description = "amnezia vpn service (awg-quick)";
      after = [ "network.target" ];

      serviceConfig =
        let awg-quick = "${unstable.amneziawg-tools}/bin/awg-quick";
        in {
          Type = "oneshot";
          RemainAfterExit =
            true; # So systemd considers the service 'active' even after the start script exits
          ExecStart = [ "${awg-quick} up ${awg-config}/awg.conf" ];
          ExecStop = [ "${awg-quick} down ${awg-config}/awg.conf" ];

        };
      path = [ unstable.amneziawg-tools ];
    };
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
