{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.nvidia;
  usingNvidia = lib.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  options.traits.nvidia = {
    enable = lib.mkEnableOption "NVIDIA drivers";
    nvk.enable = lib.mkEnableOption "NVK specialisation";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        # NOTE: this is experiemental
        boot.kernelParams = lib.optional usingNvidia "nvidia_drm.fbdev=1";

        services.xserver.videoDrivers = [ "nvidia" ];

        hardware = {
          graphics.extraPackages = [ pkgs.vaapiVdpau ]; # TODO: does this work...?
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
              # required for GSP firmware
              kernelParams = [ "nouveau.config=NvGspRm=1" ];
              # we want early KMS 
              # https://wiki.archlinux.org/title/Kernel_mode_setting#Early_KMS_start
              initrd.kernelModules = [ "nouveau" ];
            };

            # TODO: make sure we don't need this anymore
            environment.sessionVariables = {
              MESA_VK_VERSION_OVERRIDE = "1.3";
            };

            hardware.graphics.extraPackages = lib.mkForce [ ];

            services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];

            system.nixos.tags = [ "with-nvk" ];
          };
        };
      })
    ]
  );
}
