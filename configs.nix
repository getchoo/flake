{
  lib,
  withSystem,
  inputs,
  self,
  ...
}: let
  mkModulesFor = type: extra:
    lib.concatLists [
      (lib.attrValues self."${type}Modules")
      extra
    ];

  nixosModules = mkModulesFor "nixos" [
    inputs.agenix.nixosModules.default
    inputs.hm.nixosModules.home-manager
  ];

  darwinModules = mkModulesFor "darwin" [
    inputs.hm.darwinModules.home-manager
  ];
in {
  imports = [
    ./systems/deploy.nix
    ./modules/flake/configurations.nix
  ];

  configurations = {
    home = {
      builder = inputs.hm.lib.homeManagerConfiguration;
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

      users = {
        seth = {};
      };
    };

    nixos = {
      builder = inputs.nixpkgs.lib.nixosSystem;

      systems = {
        glados = {
          modules = nixosModules;
        };

        glados-wsl = {
          modules = nixosModules;
        };

        atlas = {
          builder = inputs.nixpkgs-stable.lib.nixosSystem;
          system = "aarch64-linux";
          modules = nixosModules;
        };
      };
    };

    darwin = {
      builder = inputs.darwin.lib.darwinSystem;

      systems = {
        caroline = {
          modules = darwinModules;
        };
      };
    };
  };

  flake.legacyPackages.x86_64-linux = withSystem "x86_64-linux" ({pkgs, ...}: {
    openWrtImages = {
      turret = pkgs.callPackage ./systems/turret {
        inherit (inputs) openwrt-imagebuilder;
      };
    };
  });
}
