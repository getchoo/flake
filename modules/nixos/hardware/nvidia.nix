{
  config,
  lib,
  ...
}: let
  cfg = config.hardware.nvidia;
  inherit (lib) mkEnableOption mkIf;
in {
  options.hardware.nvidia.enable = mkEnableOption "enable nvidia support";

  config = mkIf cfg.enable {
    hardware.enable = true;

    hardware = {
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
      };

      opengl = {
        enable = true;
        # make steam work
        driSupport32Bit = true;
      };
    };
  };
}
