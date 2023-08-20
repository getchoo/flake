{
  self,
  inputs,
  ...
}: let
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
  mkDeployNodes = hosts:
    inputs.nixpkgs.lib.genAttrs hosts (host: let
      system = self.nixosConfigurations.${host};
      inherit (system) pkgs;
      inherit (deployPkgs pkgs) deploy-rs;
    in {
      sshUser = "root";
      hostname = system.config.networking.hostName;
      profiles.system.path = deploy-rs.lib.activate.nixos system;
    });
}
