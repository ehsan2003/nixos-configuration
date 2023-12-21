{
  description = "Ehsan's system configuration";
  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    packages."x86_64-linux".iso = inputs.self.nixosConfigurations.iso.config.system.build.isoImage;
    packages."x86_64-linux".usb = inputs.self.nixosConfigurations.usb.config.system.build.sdImage;
    nixosConfigurations =
      let
        system = "x86_64-linux";
        specialArgs = inputs // {
          unstable = inputs.unstable.legacyPackages.${system};
          secrets = nixpkgs.lib.importJSON /etc/secrets.json;
        };
      in
      {
        base = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/base.nix ];
        };

        nixos-laptop = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/laptop.nix ];
        };
        nixos-home-desktop = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/home-pc.nix ];
        };
        usb = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ 
            ./hosts/usb.nix 
          ];
        };
        iso = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [ ./hosts/iso.nix ];
        };
      };
  };
}
