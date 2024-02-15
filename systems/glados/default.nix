{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./nvidia.nix

    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  archetypes.personal.enable = true;

  desktop = {
    enable = true;
    gnome.enable = true;
  };

  traits = {
    containers.enable = true;
    tailscale.enable = true;
    zram.enable = true;
  };

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services = {
    flatpak.enable = true;
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

  system.stateVersion = "23.11";
}
