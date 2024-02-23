{ nur, pkgs, ... }: {
  home-manager.users.ehsan = {
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
}
