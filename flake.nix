{
  inputs = {
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    getchoo = {
      url = "github:getchoo/overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgsUnstable,
    pre-commit-hooks,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    mkPkgsFor = pkgs: forAllSystems (system: import pkgs {inherit system;});
    channels = {
      nixpkgs = mkPkgsFor nixpkgs;
      nixpkgsUnstable = mkPkgsFor nixpkgsUnstable;
    };

    util = import ./util {
      inherit (nixpkgs) lib;
      inherit inputs;
    };
    inherit (util.host) mapHosts;
    inherit (util.user) mapHMUsers;

    users = import ./users {inherit inputs;};
    hosts = import ./hosts {inherit inputs;};
  in {
    checks = forAllSystems (system: {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };
    });

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      with pkgs; {
        default = mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          packages = [
            alejandra
            deadnix
            statix
          ];
        };
      });

    formatter = forAllSystems (system: channels.nixpkgs.${system}.alejandra);

    homeConfigurations = forAllSystems (system: mapHMUsers (users.users {inherit system;}));

    nixosConfigurations = mapHosts hosts;
  };
}
