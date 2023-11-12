{
  description = "Ehsan's system configuration";

  # This is the standard format for flake.nix.
  # `inputs` are the dependencies of the flake,
  # and `outputs` function will return all the build results of the flake.
  # Each item in `inputs` will be passed as a parameter to
  # the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos-unstable branch here
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
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # `outputs` are all the build result of the flake.
  #
  # A flake can have many use cases and different types of outputs.
  # 
  # parameters in function `outputs` are defined in `inputs` and
  # can be referenced by their names. However, `self` is an exception,
  # this special parameter points to the `outputs` itself(self-reference)
  # 
  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  outputs = { self, nixpkgs, ... }@inputs: {
    packages."x86_64-linux".iso = inputs.self.nixosConfigurations.iso.config.system.build.isoImage;
    nixosConfigurations = {
      # By default, NixOS will try to refer the nixosConfiguration with
      # its hostname, so the system named `nixos-test` will use this one.
      # However, the configuration name can also be specified using:
      #   sudo nixos-rebuild switch --flake /path/to/flakes/directory#<name>
      #
      # The `nixpkgs.lib.nixosSystem` function is used to build this
      # configuration, the following attribute set is its parameter.
      #
      # Run the following command in the flake's directory to
      # deploy this configuration on any NixOS system:
      #   sudo nixos-rebuild switch --flake .#nixos-test
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
