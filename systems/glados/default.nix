{
  lib,
  self,
  ...
}: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    self.nixosModules.desktop
    self.nixosModules.gnome
  ];

  features = {
    tailscale.enable = true;
    virtualisation.enable = true;
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
    fwupd.enable = true;
  };

  # set energy preference for pstate driver
  systemd.tmpfiles.rules = let
    nproc = 12;
  in
    builtins.map
    (n: "w /sys/devices/system/cpu/cpufreq/policy${builtins.toString n}/energy_performance_preference - - - - ${"balance_performance"}")
    (lib.range 0 (nproc - 1));

  powerManagement.cpuFreqGovernor = "powersave";

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    swapDevices = 1;
    memoryPercent = 50;
  };
}
