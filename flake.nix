{
  description = "Ehsan's system configuration";
  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "unstable";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    nix-alien.url = "github:thiagokokada/nix-alien";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  outputs = { self, nixpkgs, nixvim, ... }@inputs:
    let
      nixvim' = nixvim.legacyPackages.${system};
      nvim = nixvim'.makeNixvimWithModule {
        pkgs = inputs.unstable.legacyPackages.${system};
        module = import ./programming/nixvim;
      };
      system = "x86_64-linux";
      installing = builtins.getEnv "INSTALLING" == "1";
      secrets-file =
        if installing then /mnt/etc/secrets.nix else /etc/secrets.nix;
      secrets = import secrets-file;
      hardware-configuration = (if installing then
        /mnt/etc/nixos/hardware-configuration.nix
      else
        /etc/nixos/hardware-configuration.nix);
      system-definer = (secrets: hw:
        let
          specialArgs = inputs // {
            unstable = import inputs.unstable {
              inherit system;
              config.allowUnfree = true;
            };
            inherit hardware-configuration;
            inherit secrets;

          };
        in {
          base = {
            inherit specialArgs system;
            modules = [ ./hosts/base.nix ];
          };
          nixos-old-laptop = {
            inherit specialArgs system;
            modules = [ ./hosts/old-laptop.nix ];
          };

          nixos-laptop = {
            inherit specialArgs system;
            modules = [ ./hosts/laptop.nix ];
          };
          nixos-home-desktop = {
            inherit specialArgs system;
            modules = [ ./hosts/home-pc.nix ];
          };

          tablet = {
            inherit specialArgs system;
            modules = [ ./hosts/tablet.nix ];
          };

          usb = {
            inherit specialArgs system;
            modules = [ ./hosts/usb.nix ];
          };
          iso = {
            inherit specialArgs system;
            modules = [ ./hosts/iso.nix ];
          };
        });
    in {
      packages."x86_64-linux".nvim = nvim;
      packages."x86_64-linux".iso =
        inputs.self.nixosConfigurations.iso.config.system.build.isoImage;
      packages."x86_64-linux".usb =
        inputs.self.nixosConfigurations.usb.config.system.build.sdImage;
      nixosConfigurations =
        builtins.mapAttrs (name: value: (nixpkgs.lib.nixosSystem value))
        (system-definer secrets hardware-configuration);
      inherit system-definer;
    };
}
