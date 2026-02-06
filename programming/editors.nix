{
  config,
  pkgs,
  nixvim,
  unstable,
  ...
}@inputs:
let
  system = "x86_64-linux";
  nixvim' = nixvim.legacyPackages.${system};
  nvim = nixvim'.makeNixvimWithModule {
    pkgs = unstable;
    module = import ./nixvim;
  };
  userName = config.userConfiguration.name;
  userFullName = config.userConfiguration.fullName;
  userEmail = config.userConfiguration.email;
in
{
  environment.systemPackages = [
    pkgs.neovide
    pkgs.glrnvim
    nvim
  ];
  home-manager.users.${userName} = {
    programs = {
      git = {
        enable = true;
        settings.user.name = userFullName;
        settings.user.email = userEmail;
        settings.init = {
          defaultBranch = "main";
        };
      };
    };
  };

  environment.shellAliases.nv = "neovide --fork";
}
