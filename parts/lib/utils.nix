{inputs, ...}: let
  deployPkgs = pkgs:
    import pkgs.path {
      inherit (pkgs) system;
      overlays = [
        inputs.deploy-rs.overlay
        (_: prev: {
          deploy-rs = {
            inherit (pkgs) deploy-rs;
            inherit (prev.deploy-rs) lib;
          };
        })
      ];
    };
in {
  mkDeployNodes = builtins.mapAttrs (_: system: let
    inherit (deployPkgs system.pkgs) deploy-rs;
    type =
      if system.pkgs.stdenv.isLinux
      then "nixos"
      else "darwin";
  in {
    sshUser = "root";
    hostname = system.config.networking.hostName;
    profiles.system.path = deploy-rs.lib.activate.${type} system;
  });
}
