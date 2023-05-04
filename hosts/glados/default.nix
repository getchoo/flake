_: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
  ];

  getchoo = {
    desktop.gnome.enable = true;
    hardware = {
      enable = true;
      nvidia.enable = true;
    };
    nixos.virtualisation.enable = true;
  };

  home-manager.users.seth = {
    desktop = {
      enable = true;
      gnome.enable = true;
    };
  };

  environment.etc."environment".text = ''
    LIBVA_DRIVER_NAME=vdpau
  '';

  networking.hostName = "glados";
  powerManagement.cpuFreqGovernor = "ondemand";

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    swapDevices = 1;
    memoryPercent = 50;
  };

  system.stateVersion = "23.05";
}
