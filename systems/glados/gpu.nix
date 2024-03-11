{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    opengl.extraPackages = [pkgs.vaapiVdpau];
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      modesetting.enable = true;
    };
  };

  specialisation = {
    nvk.configuration = {
      boot = {
        kernelParams = ["nouveau.config=NvGspRm=1"];
        initrd.kernelModules = ["nouveau"];
      };

      hardware.opengl.extraPackages = lib.mkForce [];

      services.xserver.videoDrivers = lib.mkForce ["modesetting"];

      system.nixos.tags = ["with-nvk"];
    };
  };
}
