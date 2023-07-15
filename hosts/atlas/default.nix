{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./miniflux.nix
    ./nginx.nix
    ./prometheus.nix
  ];

  _module.args.nixinate = {
    host = "atlas";
    sshUser = "root";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  boot = {
    binfmt.emulatedSystems = ["x86_64-linux" "i686-linux"];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
  };

  getchoo.server.secrets.enable = true;

  networking = {
    domain = "mydadleft.me";
    hostName = "atlas";
  };

  nix.settings.allowed-users = ["bob"];

  users.users = {
    atlas = {
      extraGroups = ["wheel"];
      isNormalUser = true;
      shell = pkgs.bash;
      passwordFile = config.age.secrets.userPassword.path;
    };

    bob = {
      isNormalUser = true;
      shell = pkgs.bash;
    };
  };

  zramSwap.enable = true;
}
