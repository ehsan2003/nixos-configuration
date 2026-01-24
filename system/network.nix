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
  # networking.firewall.checkReversePath = "loose"; 
  services.expressvpn.enable = true;
  services.openvpn.servers = {
    openvpn = {
      autoStart = false;
      config = secrets.openvpn;
      updateResolvConf = true;
    };
  };

  # programs.amnezia-vpn.enable = true;
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
  programs.throne.enable = true;
  programs.throne.tunMode.enable = true;

  environment.systemPackages = [
    (pkgs.callPackage ./slipstream.nix { })
    pkgs.xray
    pkgs.v2ray
    unstable.tor-browser
    unstable.sing-box
    unstable.v2raya
    unstable.tun2socks
    unstable.throne
    unstable.amnezia-vpn
    unstable.amneziawg-go
    unstable.amneziawg-tools
    unstable.tor
    pkgs.expressvpn
  ];
  services.snowflake-proxy.enable = true;
  services.dbus.packages = [ unstable.amnezia-vpn ];

  systemd = {
    packages = [ unstable.amnezia-vpn ];

    services.amnezia = {
      enable = true;
      description = "amnezia vpn service (awg-quick)";
      after = [ "network.target" ];

      serviceConfig = let awg-quick = "${pkgs.amneziawg-tools}/bin/awg-quick";
      in {
        User = "root"; # Already correct - root has necessary permissions
        Type = "oneshot";
        RemainAfterExit = true;

        # Add necessary capabilities
        AmbientCapabilities =
          [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW" ];
        CapabilityBoundingSet =
          [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW" ];

        # Allow network configuration
        PrivateNetwork = false;

        # Ensure it can modify system network settings
        RestrictAddressFamilies =
          [ "AF_NETLINK" "AF_INET" "AF_INET6" "AF_UNIX" ];

        # Allow the service to interact with systemd-resolved if needed
        SystemCallFilter = [ "@network-io" "@system-service" ];

        # Original commands
        ExecStart = [ "${awg-quick} up ${awg-config}/awg.conf" ];
        ExecStop = [ "${awg-quick} down ${awg-config}/awg.conf" ];
      };

      # Expand path to include all needed tools
      path = [
        unstable.amneziawg-tools
        pkgs.iproute2 # For ip command
        pkgs.openresolv # For resolvconf
        pkgs.coreutils # For basic commands
      ];
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
