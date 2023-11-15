{
  lib,
  inputs,
  self,
  ...
}: let
  targets = ["atlas"];

  getDeploy = pkgs:
    (import pkgs.path {
      inherit (pkgs) system;
      overlays = [
        inputs.deploy.overlay
        (_: prev: {
          deploy-rs = {
            inherit (pkgs) deploy-rs;
            inherit (prev.deploy-rs) lib;
          };
        })
      ];
    })
    .deploy-rs;

  getType = pkgs:
    if pkgs.stdenv.isDarwin
    then "darwin"
    else "nixos";

  toDeployNode = hostname: system: {
    sshUser = "root";
    inherit hostname;
    profiles.system.path = (getDeploy system.pkgs).lib.activate.${getType system.pkgs} system;
  };
in {
  flake.deploy = {
    remoteBuild = true;
    fastConnection = false;
    nodes = lib.pipe (self.nixosConfigurations // self.darwinConfigurations) [
      (lib.getAttrs targets)
      (lib.mapAttrs toDeployNode)
    ];
  };
}
