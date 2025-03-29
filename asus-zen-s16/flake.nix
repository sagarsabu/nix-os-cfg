{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "nixpkgs/nixos-24-11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nur,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        # unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # use this variant if unfree packages are needed:
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

        nur = import nur {
          nurpkgs = prev;
          pkgs = prev;
        };
      };

    in
    {
      nixosConfigurations = {
        "sagar-zen-s16-laptop" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [
            # Overlays-module makes "pkgs.unstable" available in configuration.nix
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ overlay-unstable ];
              }
            )
            ./configuration.nix
          ];
        };
      };
    };
}
