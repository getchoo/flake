{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.virtualisation;
  inherit (lib) mkEnableOption mkIf;
in {
  options.features.virtualisation.enable = mkEnableOption "enable podman";

  config.virtualisation = mkIf cfg.enable {
    podman = {
      enable = true;
      enableNvidia = true;
      extraPackages = with pkgs; [podman-compose];
      autoPrune.enable = true;
    };
    oci-containers.backend = "podman";
  };
}
