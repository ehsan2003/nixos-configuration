{ pkgs, fenix, unstable, ... }: {
  imports = [ ./editors.nix ./virtualisation.nix ];
  # git 
  home-manager.users.ehsan = {
    programs = {
      git = {
        enable = true;
        userName = "ehsan";
        userEmail = "ehsan2003.2003.382@gmail.com";
        extraConfig = { init = { defaultBranch = "main"; }; };
      };
    };
  };
  programs.git.config = { init = { defaultBranch = "main"; }; };

  nixpkgs.overlays = [ fenix.overlays.default ];
  environment.systemPackages = with pkgs; [
    nodejs
    yarn
    python310
    ghc
    git
    gcc
    unstable.deno
    docker-compose
    cloc

    cargo-watch
    (pkgs.fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    pre-commit
  ];
}
