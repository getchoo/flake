{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHardware.nvidia;
  inherit (lib) mkEnableOption mkIf;
in {
  options.myHardware.nvidia.enable = mkEnableOption "enable nvidia support";

  config = mkIf cfg.enable {
    myHardware.enable = true;

    hardware = {
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
      };

      opengl = {
        enable = true;
        # make steam work
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          vaapiVdpau
        ];
      };
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
