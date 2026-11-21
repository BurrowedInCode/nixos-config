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
    let
      system = "x86_64-linux";
      mkHost =
        path:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ path ];
        };
    in
    {
      nixosConfigurations = {
        nixos = mkHost ./hosts/pc;
        laptop = mkHost ./hosts/laptop;
        server = mkHost ./hosts/server;
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
