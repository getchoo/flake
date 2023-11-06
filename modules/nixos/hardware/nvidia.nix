{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hardware.nvidia;
  inherit (lib) mkEnableOption mkIf;
in {
  options.hardware.nvidia.enable = mkEnableOption "enable nvidia support";

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "vdpau";
      VDPAU_DRIVER = "nvidia";
    };

    hardware = {
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
      };

      opengl = {
        extraPackages = [pkgs.vaapiVdpau];
      };
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
