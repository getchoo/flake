{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.getchoo.base.virtualisation;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.base.virtualisation.enable = mkEnableOption "enable podman";

  config.virtualisation = mkIf cfg.enable {
    podman = {
      enable = true;
      enableNvidia = true;
      extraPackages = with pkgs; [podman-compose];
    };
    oci-containers.backend = "podman";
  };
}
