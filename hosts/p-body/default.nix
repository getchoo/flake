{
  config,
  guzzle_api,
  pkgs,
  ...
}: {
  imports = [
    ./buildMachines.nix
    ./grafana.nix
    ./loki.nix
    ./nginx.nix
    ./victoriametrics.nix
  ];

  boot = {
    loader.grub = {
      enable = true;
      efiSupport = false;
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
      matchConfig.name = "ens3";
      networkConfig.DHCP = "no";
      address = [
        "something/32"
      ];
      routes = [
        {routeConfig = {Destination = "something";};}
        {
          routeConfig = {
            Gateway = "something";
            GatewayOnLink = true;
          };
        }
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
    extraGroups = ["wheel"];
    isNormalUser = true;
    shell = pkgs.bash;
    passwordFile = config.age.secrets.userPassword.path;
  };

  zramSwap.enable = true;
}
