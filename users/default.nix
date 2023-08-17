{
  inputs,
  self,
  ...
}: let
  inherit (self.lib.configs) genHMCfgs genHMModules;

  users = {
    seth = {
      nixpkgsArgs = {
        overlays = with inputs; [nur.overlay getchoo.overlays.default];
      };
      modules = [
        inputs.nix-index-database.hmModules.nix-index
      ];
    };
  };
in {
  flake = {
    homeConfigurations = genHMCfgs users;
    homeManagerModules = genHMModules users;
  };
}
