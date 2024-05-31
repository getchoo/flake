{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.traits.containers;
  enableNvidia = lib.elem "nvidia" (config.services.xserver.videoDrivers or []);
in {
  options.traits.containers = {
    enable = lib.mkEnableOption "containers support";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        virtualisation = {
          podman = {
            enable = true;
            extraPackages = with pkgs; [podman-compose];
            autoPrune.enable = true;
          };

          oci-containers.backend = "podman";
        };
      }

      (lib.mkIf enableNvidia {
        hardware.nvidia-container-toolkit.enable = true;
      })
    ]
  );
}
