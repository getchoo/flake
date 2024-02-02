{
  withSystem,
  inputs,
  self,
  ...
}: let
  common = import ./systems/common.nix {inherit inputs self;};
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
          modules = common.personal;
        };

        glados-wsl = {
          modules = common.personal;
        };

        atlas = {
          builder = inputs.nixpkgs-stable.lib.nixosSystem;
          system = "aarch64-linux";
          modules = common.server;
        };
      };
    };

    darwin = {
      builder = inputs.darwin.lib.darwinSystem;

      systems = {
        caroline = {
          modules = common.darwin;
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
