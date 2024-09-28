Here is an improved README with more details about using the NixOS configuration:

# My personal NixOS configuration

This repository contains my personal NixOS configuration files. Before using this configuration, you will need:

## Secret management

- A `/etc/secrets.nix` file containing sensitive information like API keys. There are 4 required keys:
  - `proxy` - A shell script that runs a proxy on port 1080
  - `OPENAI_API_KEY` - OpenAI's API key
  - `location` - an attributeset of Latitude and longitude of your current location (for praytimes and redshift)
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
- ** add secrets.nix file **
- run `sudo nixos-install --flake github:ehsan2003/nixos-configuration#<system-name> --impure`
- wait for installation

## Usb installation

this configuration contains a file (./hosts/usb.nix) which is a configuration for installing the os on the usb (not iso but complete installation) with disk encryption
for this purpose we first need to use disko to partition the system and mount stuff

```sh
sudo nix run github:nix-community/disko -- --mode disko hosts/usb-disko.nix
```

adding a password for the disk encryption

```sh
echo -n "some-super-secure-password" > /tmp/secret.key
```

and installing the os :

```sh
sudo nixos-install --flake .#usb --impure --root /mnt
```

and have fun :)

### A few steps after installation

altough almost everything is preconfigured there are still a few things left to do

- logging in to telegram and other apps
- setting telegram cofigurations ( its not feasible to configure it through nix stuff)
- enabling web extensions ( they are already installed but its necessary to configure them and enable them )
- setting up v2raya proxies
- logging github using gh
- and probably more
