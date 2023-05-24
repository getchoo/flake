{
  config,
  guzzle_api,
  modulesPath,
  pkgs,
  self,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-image.nix")
    ./buildMachines.nix
    ./cachix.nix
    ./forgejo.nix
    ./grafana.nix
    ./hydra.nix
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

  age.secrets.authGH = {
    file = "${self}/secrets/hosts/${config.networking.hostName}/authGH.age";
    mode = "440";
    owner = config.users.users.root.name;
    inherit (config.users.users.hydra) group;
  };

  getchoo.server.secrets.enable = true;

  networking = {
    domain = "mydadleft.me";
    hostName = "p-body";
  };

  nix.extraOptions = ''
    !include ${config.age.secrets.authGH.path}
  '';

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

  system.stateVersion = "22.11";

  users.users = let
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeEbjzzzwf9Qyl0JorokhraNYG4M2hovyAAaA6jPpM7 seth@glados"
    ];
  in {
    root = {inherit openssh;};
    p-body = {
      extraGroups = ["wheel"];
      isNormalUser = true;
      shell = pkgs.bash;
      passwordFile = config.age.secrets.userPassword.path;
      inherit openssh;
    };
  };

  zramSwap.enable = true;
}
