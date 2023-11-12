Here is an improved README with more details about using the NixOS configuration:

# My personal NixOS configuration

This repository contains my personal NixOS configuration files. Before using this configuration, you will need:

- A `/etc/secrets.json` file containing sensitive information like API keys. There are 4 required keys:
  - `openvpn` - OpenVPN configuration
  - `proxy` - A shell script that runs a proxy on port 1080 
  - `OPENAI_API_KEY` - OpenAI's API key
  - `location` - Latitude and longitude of your current location (for praytimes and redshift)
- A hardware configuration file at `/etc/nixos/hardware-configuration.nix` for your system (not needed for building the ISO file)

You can build the configuration for different systems:

## Home Desktop

```bash
sudo nixos-rebuild switch --flake .#nixos-home-desktop --impure # For home PC
```

## Laptop

```bash
sudo nixos-rebuild switch --flake .#nixos-laptop --impure # For laptop
```

## ISO File

```bash
sudo nixos-rebuild switch --flake .#iso --impure # For the ISO file
```

## installation steps
- make a bootable nixos iso ( it can be the iso built with this configuration itself in this case we have less files needed for download)
- boot iso in system
- create needed partitions
- mount needed partitions to /mnt and /mnt/boot ( and any other partition )
- generate nixos configuration
- ** copy /mnt/nixos/hardware-configuration.nix to /etc/nixos/hardware-configuration.nix **
- ** add secrets.json file **
- run `sudo nixos-install --flake github:ehsan2003/nixos-configuration#<system-name> --impure`
- wait for installation
 
