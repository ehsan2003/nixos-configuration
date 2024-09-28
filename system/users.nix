{ ... }: {
  users.users.ehsan = {
    hashedPassword =
      "$y$j9T$2nOFoeEIw1pVXxpVrAvNb1$LRGyoksEO8Z8G36xU4d3Jdm8BIm9hYfmWZpK8SQQK3D"; # ehsan
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
}
