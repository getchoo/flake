{
  self,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) filterAttrs;
  inherit (self) darwinConfigurations nixosConfigurations;

  targets = ["atlas" "p-body" "caroline"];

  targets' = filterAttrs (n: _: elem n targets) (nixosConfigurations // darwinConfigurations);
in {
  flake.deploy = {
    remoteBuild = true;
    fastConnection = true;
    nodes = self.lib.utils.mkDeployNodes targets';
  };
}
