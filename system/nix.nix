{
  config,
  nur,
  pkgs,
  ...
}:
let
  userName = config.userConfiguration.name;
in
{
  home-manager.users.${userName} = {
    nixpkgs.overlays = [ (self: super: { fcitx-engines = pkgs.fcitx5; }) ];
    home.stateVersion = "22.11";
  };
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import nur {
      inherit pkgs;
      nurpkgs = pkgs;
    };
  };
  programs.nix-ld.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };
  systemd.services.nix-daemon.environment = {
    # socks5h mean that the hostname is resolved by the SOCKS server
    https_proxy = "socks5h://localhost:1080";
    # https_proxy = "http://localhost:7890"; # or use http prctocol instead of socks5
  };
}
