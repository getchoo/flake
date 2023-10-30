{
  lib,
  self,
  ...
}: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ../../modules/nixos/features/tailscale.nix
    ../../modules/nixos/features/virtualisation.nix
    self.nixosModules.desktop
    self.nixosModules.gnome
  ];

  boot = {
    kernelParams = ["amd_pstate=active"];
    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.vfs_cache_pressure" = 500;
      "vm.dirty_background_ratio" = 1;
      "vm.dirty_ratio" = 50;
    };
  };

  features = {
    tailscale.enable = true;
    virtualisation.enable = true;
  };

  hardware = {
    nvidia.enable = true;
    ssd.enable = true;
  };

  home-manager.users.seth = {
    desktop.enable = true;
  };

  networking.hostName = "glados";

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services = {
    flatpak.enable = true;
    fwupd.enable = true;
  };

  systemd = {
    services."prepare-kexec".wantedBy = ["multi-user.target"];
    tmpfiles.rules = let
      nproc = 12;
    in
      builtins.map
      (n: "w /sys/devices/system/cpu/cpu${builtins.toString n}/cpufreq/energy_performance_preference - - - - ${"balance_performance"}")
      (lib.range 0 (nproc - 1));
  };

  powerManagement.cpuFreqGovernor = "powersave";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    swapDevices = 1;
    memoryPercent = 50;
  };
}
