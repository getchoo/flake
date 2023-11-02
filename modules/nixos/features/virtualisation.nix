{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.virtualisation;
in {
  options.features.virtualisation = {
    enable = lib.mkEnableOption "enable podman";
  };

  config.virtualisation = lib.mkIf cfg.enable {
    podman = {
      enable = true;
      enableNvidia = lib.mkDefault (config.hardware.nvidia.enable or false);
      extraPackages = with pkgs; [podman-compose];
      autoPrune.enable = true;
    };

    oci-containers.backend = "podman";
  };
}
