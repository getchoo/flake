{
  self,
  lib,
  ...
}: let
  systems = ["atlas" "p-body"];

  deployedSystems =
    lib.filterAttrs
    (n: _: builtins.elem n systems)
    self.nixosConfigurations;
in {
  flake.deploy = {
    remoteBuild = true;
    nodes = self.lib.utils.mkDeployNodes deployedSystems;
  };
}
