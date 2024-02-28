{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.traits.containers;
in {
  options.traits.containers = {
    enable = lib.mkEnableOption "containers support";
  };

  config.virtualisation = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        podman = {
          enable = true;
          extraPackages = with pkgs; [podman-compose];
          autoPrune.enable = true;
        };

        oci-containers.backend = "podman";
      }

      (let
        enable = lib.mkDefault (
          lib.elem "nvidia" (config.services.xserver.videoDrivers or [])
        );
      in
        if (options.virtualisation.containers ? cdi)
        then {
          containers.cdi.dynamic.nvidia = {inherit enable;};
        }
        else {
          podman.enableNvidia = enable;
        })
    ]
  );
}
