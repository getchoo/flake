{
  inputs,
  self,
  ...
}: {
  flake.homeConfigurations = let
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
  in
    self.lib.configs.genHMCfgs users;
}
