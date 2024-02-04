{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./miniflux.nix
    ./nginx.nix
    ./teawiebot.nix
  ];

  suites.server.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    domain = "mydadleft.me";
    networkmanager.enable = false;
  };

  services = {
    resolved.enable = false;
    # not sure why this fails...
    # context: https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
    logrotate.checkConfig = false;
  };

  users.users.atlas = {
    isNormalUser = true;
    shell = pkgs.bash;
    hashedPasswordFile = config.age.secrets.userPassword.path;
  };

  system.stateVersion = "23.05";

  zramSwap.enable = true;
}
