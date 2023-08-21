{
  self,
  lib,
  ...
}: let
  targets = ["atlas" "p-body"];

  targets' = lib.filterAttrs (n: _: builtins.elem n targets) self.nixosConfigurations;
in {
  flake.deploy = {
    remoteBuild = true;
    fastConnection = true;
    nodes = self.lib.utils.mkDeployNodes targets';
  };
}
