{ config, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ./hardware-configuration.nix
    ./miniflux.nix
    ./nginx.nix
    ./nixpkgs-tracker-bot.nix
    ./teawiebot.nix
  ];

  _module.args.nixinate = {
    host = config.networking.hostName;
    sshUser = "root";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  archetypes.server.enable = true;
  base.networking.enable = false;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    domain = "getchoo.com";
    hostName = "atlas";
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  system.stateVersion = "23.05";
}
