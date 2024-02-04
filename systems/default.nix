{
  withSystem,
  inputs,
  ...
}: {
  imports = [./deploy.nix];

  configurations = {
    nixos = {
      builder = inputs.nixpkgs.lib.nixosSystem;

      modules = [
        inputs.agenix.nixosModules.default
        inputs.hm.nixosModules.home-manager
      ];

      systems = {
        glados = {};

        glados-wsl = {};

        atlas = {
          builder = inputs.nixpkgs-stable.lib.nixosSystem;
          system = "aarch64-linux";
        };
      };
    };

    darwin = {
      builder = inputs.darwin.lib.darwinSystem;

      modules = [
        inputs.hm.darwinModules.home-manager
      ];

      systems = {
        caroline = {};
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
