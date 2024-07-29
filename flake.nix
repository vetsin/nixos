{
  description = "nixos home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let
    inherit (self) outputs;
    systems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules/nixos;
    #homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      nixnuc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/nixnuc.nix
        ];
      };
    };

    #homeConfigurations = {
    #  "vetsin@nixnuc" = home-manager.lib.homeManagerConfiguration {
    #    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #    extraSpecialArgs = {inherit inputs outputs;};
    #    modules = [
    #      ./home-manager/home.nix
    #    ];
    #  };
    #};

  };
}
