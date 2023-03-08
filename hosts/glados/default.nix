{
  config,
  home-manager,
  ...
}: {
  imports = [
    ../../profiles/desktop/gnome
    ../../profiles/hardware/nvidia.nix
    ../../profiles/virtualisation.nix
    ../../users/seth
    ./boot.nix
    ./hardware-configuration.nix
    ./network.nix
    ./services.nix
  ];

  home-manager.users.seth = {
    imports = [
      ../../users/seth/desktop/gnome
    ];
  };

  environment.etc."environment".text = ''
    LIBVA_DRIVER_NAME=vdpau
  '';

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
