{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./miniflux.nix
    ./nginx.nix
  ];

  age.secrets.teawiebot.file = ../../secrets/systems/atlas/teawieBot.age;

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
    teawiebot = {
      enable = true;
      environmentFile = config.age.secrets.teawiebot.path;
    };
  };

  users.users.atlas = {
    isNormalUser = true;
    shell = pkgs.bash;
    passwordFile = config.age.secrets.userPassword.path;
  };

  zramSwap.enable = true;
}
