{ config, lib, ... }:
let
  cfg = config.traits.nvidia;
in
{
  options.traits.nvidia = {
    enable = lib.mkEnableOption "NVIDIA drivers";

    openModules.enable = lib.mkEnableOption "open kernel modules for the proprietary driver" // {
      # unlike nixpkgs, i know all of my nvidia cards should prefer the open modules after 560
      default = lib.versionAtLeast config.hardware.nvidia.package.version "560";
    };

    nvk.enable = lib.mkEnableOption "an NVK specialisation";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {
          package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.latest;

          open = cfg.openModules.enable;
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

      (lib.mkIf config.traits.containers.enable {
        hardware.nvidia-container-toolkit.enable = true;
      })
    ]
  );
}
