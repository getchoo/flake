{
  config,
  pkgs,
  secretsDir,
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

  age.secrets.teawiebot.file = secretsDir + "/teawieBot.age";

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
    hashedPasswordFile = config.age.secrets.userPassword.path;
  };

  zramSwap.enable = true;
}
