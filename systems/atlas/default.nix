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

  _module.args.nixinate = {
    host = "atlas";
    sshUser = "root";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
  };

  networking = {
    domain = "mydadleft.me";
    hostName = "atlas";
    networkmanager.enable = false;
  };

  services = {
    guzzle-api = {
      enable = true;
      domain = "api.${config.networking.domain}";
      nginx = {
        enableACME = true;
        acmeRoot = null;
        addSSL = true;
      };
    };

    resolved.enable = false;
  };

  users.users.atlas = {
    isNormalUser = true;
    shell = pkgs.bash;
    passwordFile = config.age.secrets.userPassword.path;
  };

  zramSwap.enable = true;
}