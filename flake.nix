{
  description = "NixOS and home-manager configs for my machines";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minicfg = {
      url = "path:./minicfg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cardamum = {
      url = "github:pimalaya/cardamum";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    calendula = {
      url = "github:pimalaya/calendula";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, minicfg, cardamum, calendula, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.lwa = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
      };

      homeConfigurations."kin" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit minicfg cardamum calendula; };
        modules = [ ./home.nix ];
      };
    };
}

# vi: ts=2:sw=2
