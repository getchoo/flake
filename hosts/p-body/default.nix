{
  config,
  guzzle_api,
  pkgs,
  ...
}: {
  imports = [
    ./buildMachines.nix
    ./grafana.nix
    ./hardware-configuration.nix
    ./loki.nix
    ./nginx.nix
    ./victoriametrics.nix
  ];

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };

    supportedFilesystems = ["btrfs"];
  };

  networking = {
    domain = "mydadleft.me";
    hostName = "p-body";
  };

  services = {
    guzzle-api = {
      enable = true;
      url = "https://api." + config.networking.domain;
      port = "8080";
      package = guzzle_api.packages.x86_64-linux.guzzle-api-server;
    };
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp1s0";
      networkConfig.DHCP = "ipv4";
      address = [
        "2a01:4ff:f0:eb52::1/64"
      ];
      routes = [
        {routeConfig.Gateway = "fe80::1";}
      ];
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  users.users.p-body = {
    isNormalUser = true;
    shell = pkgs.bash;
    passwordFile = config.age.secrets.userPassword.path;
  };

  zramSwap.enable = true;
}
