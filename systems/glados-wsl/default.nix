{
  lib,
  modulesPath,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    inputs.nixos-wsl.nixosModules.wsl
  ];

  archetypes.personal.enable = true;

  base = {
    networking.enable = false;
    security.enable = false;
  };

  environment = {
    noXlibs = lib.mkForce false;
    systemPackages = with pkgs; [
      wget
      wslu
    ];
  };

  networking.hostName = "glados-wsl";

  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "23.11";

  traits.tailscale.enable = true;

  wsl = {
    enable = true;
    defaultUser = "seth";
    nativeSystemd = true;
    wslConf.network = {
      hostname = "glados-wsl";
      generateResolvConf = true;
    };
    startMenuLaunchers = false;
    interop.includePath = false;
  };
}
