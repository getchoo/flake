{
  lib,
  inputs,
  self,
  ...
}: let
  targets = ["atlas"];
  configurations = self.nixosConfigurations // self.darwinConfigurations;

  getDeploy = pkgs:
    (pkgs.appendOverlays [
      inputs.deploy.overlay
      (_: prev: {
        deploy-rs = {
          inherit (pkgs) deploy-rs;
          inherit (prev.deploy-rs) lib;
        };
      })
    ])
    .deploy-rs;

  toType = system:
    {
      "Linux" = "nixos";
      "Darwin" = "darwin";
    }
    .${system};

  toDeployNode = hostname: system: {
    sshUser = "root";
    inherit hostname;
    profiles.system.path = let
      deploy = getDeploy system.pkgs;
      type = toType system.pkgs.stdenv.hostPlatform.uname.system;
    in
      deploy.lib.activate.${type} system;
  };
in {
  flake.deploy = {
    remoteBuild = true;
    fastConnection = false;
    nodes = lib.mapAttrs toDeployNode (lib.getAttrs targets configurations);
  };
}
