{ pkgs, nixvim, unstable, ... }@inputs:
let
  system = "x86_64-linux";
  nixvim' = nixvim.legacyPackages.${system};
  nvim = nixvim'.makeNixvimWithModule {
    pkgs = unstable;
    module = import ./nixvim;
  };
in {
  environment.systemPackages = [ pkgs.neovide pkgs.glrnvim nvim ];
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

  environment.shellAliases.nv = "neovide --fork";
}
