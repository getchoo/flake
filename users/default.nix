{inputs, ...}: let
  inherit (inputs) getchoo home-manager nixpkgsUnstable nur;
in {
  perSystem = {system, ...}: {
    legacyPackages.homeConfigurations = let
      inherit (home-manager.lib) homeManagerConfiguration;
      modules = [
        {
          programs.home-manager.enable = true;
        }
      ];

      extraSpecialArgs = inputs;

      pkgs = import nixpkgsUnstable {
        inherit system;
        overlays = [nur.overlay getchoo.overlays.default];
      };

      mkHMUser = username:
        homeManagerConfiguration {
          inherit pkgs extraSpecialArgs;
          modules = modules ++ ["./${username}"];
        };
    in {
      seth = mkHMUser "seth";
    };
  };
}
