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
    corepack_22
    nodejs_22
    python310
    git
    gcc
    unstable.bun
    unstable.deno
    unstable.dotnetCorePackages.dotnet_8.sdk
    cloc
    postgresql_16
    lazygit
    typescript
    unstable.aider-chat

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
  services.pgadmin.enable = true;
  services.pgadmin.initialEmail = "test";
  services.pgadmin.initialPasswordFile = "/etc/pgadminpassword";

}
