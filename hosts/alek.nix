{ pkgs, config, ... }: {
  imports = [ ./base.nix ];
  networking.hostName = "alek"; # Define your hostname.
  services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --rate 60 &";
  services.tlp.enable = true;
  environment.systemPackages = [
    pkgs.jetbrains.idea-ultimate
    pkgs.brave
  ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

}
