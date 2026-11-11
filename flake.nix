{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    dms = {
      url = "github:duxlabs-dev/dux-shell/v2.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dcal = {
      url = "github:duxlabs-dev/dux-calendar";
    };
  };
  outputs =
    inputs@{ nixpkgs, ... }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/pc
        ];
      };

      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop
        ];
      };
    };
}
