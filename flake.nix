{
  description = "Ehsan's system configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astroNvim = {
      url = "github:AstroNvim/AstroNvim";
      flake = false;
    };

    nur.url = "github:nix-community/NUR";
    nix-alien.url = "github:thiagokokada/nix-alien";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, ... }@inputs: {
    packages."x86_64-linux".iso = inputs.self.nixosConfigurations.iso.config.system.build.isoImage;
    nixosConfigurations = {
      "nixos-laptop" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";


        specialArgs = inputs // {
          unstable = inputs.unstable.legacyPackages.${system};
        };
        modules = [
          ./configuration.laptop.nix
        ];
      };
      "nixos-home-desktop" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";


        specialArgs = inputs // {
          unstable = inputs.unstable.legacyPackages.${system};
        };
        modules = [
          ./configuration.home-pc.nix
        ];
      };
      iso = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";


        specialArgs = inputs // {
          unstable = inputs.unstable.legacyPackages.${system};
        };
        modules = [
          ./iso.nix
        ];
      };
    };
  };
}
