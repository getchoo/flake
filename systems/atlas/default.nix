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

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    domain = "mydadleft.me";
    hostName = "atlas";
    networkmanager.enable = false;
  };

  services = {
    resolved.enable = false;
  };

  users.users.atlas = {
    isNormalUser = true;
    shell = pkgs.bash;
    hashedPasswordFile = config.age.secrets.userPassword.path;
  };

  system.stateVersion = "23.05";

  zramSwap.enable = true;
}
