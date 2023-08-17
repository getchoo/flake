{
  self,
  lib,
  ...
}: let
  machines = ["atlas" "p-body"];

  deployedSystems = lib.genAttrs machines (m: self.nixosConfigurations.${m});
in {
  flake.deploy = {
    remoteBuild = true;
    nodes = self.lib.utils.mkDeployNodes deployedSystems;
  };
}
