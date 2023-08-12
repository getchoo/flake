{
  self,
  inputs,
  lib,
  withSystem,
  ...
}: let
  systems = ["atlas" "p-body"];

  deployedSystems =
    lib.filterAttrs
    (n: _: builtins.elem n systems)
    self.nixosConfigurations;

  deployPkgs = import inputs.nixpkgs rec {
    system = "x86_64-linux";
    overlays = [
      inputs.deploy-rs.overlay
      (_: prev: {
        deploy-rs = {
          inherit (withSystem system (p: p.pkgs)) deploy-rs;
          inherit (prev.deploy-rs) lib;
        };
      })
    ];
  };

  mkNodes = hosts: let
    inherit (builtins) attrNames listToAttrs map;
    vals =
      map (name: let
        system = self.nixosConfigurations.${name};
      in {
        inherit name;
        value = {
          sshUser = "root";
          hostname = system.config.networking.hostName;
          profiles.system.path = deployPkgs.deploy-rs.lib.activate.nixos system;
        };
      })
      (attrNames hosts);
  in
    listToAttrs vals;
in {
  flake.deploy = {
    remoteBuild = true;
    nodes = mkNodes deployedSystems;
  };
}
