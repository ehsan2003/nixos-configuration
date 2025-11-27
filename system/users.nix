{ secrets, ... }: {
  users.users.ehsan = {
    hashedPassword = secrets.HASHED_PASSWORD; # ehsan
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
}
