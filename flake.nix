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

      system = "x86_64-linux";
      nixvim' = nixvim.legacyPackages.${system};
      nvim = nixvim'.makeNixvimWithModule {
        pkgs = inputs.unstable.legacyPackages.${system};
        module = import ./programming/nixvim;
      };
    in {
      packages."x86_64-linux".nvim = nvim;
      packages."x86_64-linux".iso =
        inputs.self.nixosConfigurations.iso.config.system.build.isoImage;
      packages."x86_64-linux".usb =
        inputs.self.nixosConfigurations.usb.config.system.build.sdImage;
      nixosConfigurations = let
        system = "x86_64-linux";
        specialArgs = inputs // {
          unstable = import inputs.unstable {
            inherit system;
            config.allowUnfree = true;
          };
          secrets = import /etc/secrets.nix;
        };
      in {
        base = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/base.nix ];
        };
        nixos-old-laptop = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/old-laptop.nix ];
        };

        nixos-laptop = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/laptop.nix ];
        };
        nixos-home-desktop = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/home-pc.nix ];
        };

        tablet = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/tablet.nix ];
        };

        usb = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/usb.nix ];
        };
        iso = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/iso.nix ];
        };
      };
    };
}
