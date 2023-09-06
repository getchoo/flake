{
  config,
  pkgs,
  guzzle_api,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./miniflux.nix
    ./nginx.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
  };

  networking = {
    domain = "mydadleft.me";
    hostName = "atlas";
  };

  services = {
    guzzle-api = {
      enable = true;
      url = "https://api." + config.networking.domain;
      port = "8080";
      package = guzzle_api.packages.x86_64-linux.guzzle-api-server;
    };
  };

  users.users.atlas = {
    isNormalUser = true;
    shell = pkgs.bash;
    passwordFile = config.age.secrets.userPassword.path;
  };

  zramSwap.enable = true;
}
