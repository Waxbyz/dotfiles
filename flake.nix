{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   
    visor-nix = {
      url = "github:Waxbyz/visor-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      vars = import ./vars.nix;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ config, ... }: {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];
      systems = [ "x86_64-linux" ];
      flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          inputs.visor-nix.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${vars.username}.imports = [ config.flake.modules.homeManager.user ];
          }
        ];
      };
    });
}
