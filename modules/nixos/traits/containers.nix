{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.containers;
in
{
  options.traits.containers = {
    enable = lib.mkEnableOption "support for containers";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        extraPackages = [ pkgs.podman-compose ];
        autoPrune.enable = true;
      };

      oci-containers.backend = "podman";
    };
  };
}
