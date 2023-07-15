{
  config,
  guzzle_api,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-image.nix")
    ./buildMachines.nix
    ./grafana.nix
    ./loki.nix
    ./nginx.nix
    ./prometheus.nix
  ];

  _module.args.nixinate = {
    host = "p-body";
    sshUser = "root";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  getchoo.server.secrets.enable = true;

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
