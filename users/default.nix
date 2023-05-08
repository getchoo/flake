{inputs, ...}: let
  mkHMUser = {
    name,
    modules ? [],
    pkgs ? import inputs.nixpkgs {system = "x86_64-linux";},
    extraSpecialArgs ? inputs,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs;
      modules =
        [
          {
            programs.home-manager.enable = true;
          }
        ]
        ++ [./${name}/home.nix]
        ++ modules;
    };
in {
  perSystem = {system, ...}: {
    legacyPackages.homeConfigurations = {
      seth = mkHMUser {
        name = "seth";
        pkgs = import inputs.nixpkgsUnstable {
          inherit system;
          overlays = with inputs; [nur.overlay getchoo.overlays.default];
        };
      };
    };
  };
}
