{ config, lib, ... }:
let
  userName = config.userConfiguration.name;
  userGroups = config.userConfiguration.extraGroups;
  secrets = config.userConfiguration.secrets;
in
{
  users.users.${userName} = {
    hashedPassword = secrets.HASHED_PASSWORD;
    isNormalUser = true;
    extraGroups = userGroups;
  };
}
