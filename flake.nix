{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    user-password.url = "file:///persist/secrets/hashed_userpw_tobias";
    user-password.flake = false;
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      disko,
      impermanence,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.cosmic-ac = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        
        modules = [
          ./system
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tobias = import ./home;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };
}
