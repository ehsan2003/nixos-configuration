{ pkgs, ... }:
let dpi = 120;
in {
  imports = [ ./base.nix ];
  networking.hostName = "nixos-laptop"; # Define your hostname.
  services.xserver.dpi = dpi;
  home-manager.users.ehsan.programs.rofi.extraConfig."dpi" = dpi;
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: ${toString dpi}  
    EOF
  '';

  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_EtERGY_PERF_POLICY_ON_AC = "performance";

  };
}
