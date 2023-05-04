{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.nixos.virtualisation;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.nixos.virtualisation.enable = mkEnableOption "enable podman";

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        enableNvidia = true;
        extraPackages = with pkgs; [podman-compose];
      };
      oci-containers.backend = "podman";
    };
  };
}
