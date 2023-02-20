{ config
, pkgs
, ...
}: {
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      nvidiaPersistenced = true;
      powerManagement.enable = true;
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

  services.xserver.videoDrivers = [ "nvidia" ];
}
