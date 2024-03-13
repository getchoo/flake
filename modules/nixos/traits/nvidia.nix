{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.nvidia;
  usingNvidia = lib.elem "nvidia" config.services.xserver.videoDrivers;
in {
  options.traits.nvidia = {
    enable = lib.mkEnableOption "NVIDIA drivers";
    nvk.enable = lib.mkEnableOption "NVK specialisation";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      boot.kernelParams = lib.optional usingNvidia "nvidia_drm.fbdev=1";

      services.xserver.videoDrivers = ["nvidia"];

      hardware = {
        opengl.extraPackages = [pkgs.vaapiVdpau];
        nvidia = {
          package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.latest;
          modesetting.enable = true;
        };
      };
    }

    (lib.mkIf cfg.nvk.enable {
      specialisation = {
        nvk.configuration = {
          boot = {
            kernelParams = ["nouveau.config=NvGspRm=1"];
            initrd.kernelModules = ["nouveau"];
          };

          environment.sessionVariables = {
            MESA_VK_VERSION_OVERRIDE = "1.3";
          };

          hardware.opengl.extraPackages = lib.mkForce [];

          services.xserver.videoDrivers = lib.mkForce ["modesetting"];

          system.nixos.tags = ["with-nvk"];
        };
      };
    })
  ]);
}
