{self, ...}: let
  targets = ["atlas" "p-body"];
in {
  flake.deploy = {
    remoteBuild = true;
    fastConnection = true;
    nodes = self.lib.utils.mkDeployNodes targets;
  };
}
