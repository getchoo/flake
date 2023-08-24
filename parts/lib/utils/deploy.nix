{inputs, ...}: let
  inherit (builtins) mapAttrs;
  inherit (inputs) deploy-rs;
in {
  mkDeployNodes = mapAttrs (_: system: let
    inherit (system) pkgs;
    deployPkgs = import pkgs.path {
      inherit (pkgs) system;
      overlays = [
        deploy-rs.overlay
        (_: prev: {
          deploy-rs = {
            inherit (pkgs) deploy-rs;
            inherit (prev.deploy-rs) lib;
          };
        })
      ];
    };

    type =
      if pkgs.stdenv.isLinux
      then "nixos"
      else "darwin";
  in {
    sshUser = "root";
    hostname = system.config.networking.hostName;
    profiles.system.path = deployPkgs.deploy-rs.lib.activate.${type} system;
  });
}
