{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.containers;
in {
  options.traits.containers = {
    enable = lib.mkEnableOption "containers support";
  };

  config.virtualisation = lib.mkIf cfg.enable {
    podman = {
      enable = true;
      enableNvidia = lib.mkDefault (builtins.elem "nvidia" (config.services.xserver.videoDrivers or []));
      extraPackages = with pkgs; [podman-compose];
      autoPrune.enable = true;
    };

    oci-containers.backend = "podman";
  };
}