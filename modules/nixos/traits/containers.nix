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
    enableNvidia = lib.mkEnableOption "the use of nvidia-container-toolkit" // {
      default = lib.elem "nvidia" config.services.xserver.videoDrivers;
      defaultText = lib.literalExpression ''
        lib.elem "nvidia" config.services.xserver.videoDrivers
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        virtualisation = {
          podman = {
            enable = true;
            extraPackages = [ pkgs.podman-compose ];
            autoPrune.enable = true;
          };

          oci-containers.backend = "podman";
        };
      }

      (lib.mkIf cfg.enableNvidia { hardware.nvidia-container-toolkit.enable = true; })
    ]
  );
}
