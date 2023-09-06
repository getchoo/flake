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
      domain = "api.${config.networking.domain}";
      nginx = {
        enableACME = true;
        acmeRoot = null;
        addSSL = true;
      };
    };
  };

  users.users.atlas = {
    isNormalUser = true;
    shell = pkgs.bash;
    passwordFile = config.age.secrets.userPassword.path;
  };

  zramSwap.enable = true;
}
