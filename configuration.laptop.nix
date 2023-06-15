{ pkgs, ... }: {
  imports = [ ./common.nix ];
  networking.hostName = "nixos-laptop"; # Define your hostname.

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  users.users.test = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      thunderbird

    ];
  };
  home-manager.users.test = {
    home.shellAliases = { v = "nvim"; };
    home.stateVersion = "22.11";
    # home.file.i3Config = import ./i3-config.nix {pkgs = pkgs;};

    programs = {
      bash.enable = true;

      rofi = {
        enable = true;
        theme = "Adapta-Nokto";
      };
      alacritty = { enable = true; };
    };

  };

  services.xserver.displayManager.sessionCommands =
    "sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 94 = Shift_L' &";
  home-manager.users.ehsan.programs.alacritty.settings.font.size = 12;

}
