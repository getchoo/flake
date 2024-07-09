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
    # these don't work well on wsl
    networking.enable = false;
    security.enable = false;
  };

  environment = {
    # i occasionally use graphics stuff
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
    interop.includePath = false; # this is so annoying
    nativeSystemd = true;
    startMenuLaunchers = false; # ditto

    wslConf.network = {
      hostname = "glados-wsl";
      generateResolvConf = true;
    };
  };
}
