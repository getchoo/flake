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
    binfmt.emulatedSystems = ["x86_64-linux" "i686-linux"];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
  };

  server.secrets.enable = true;

  networking = {
    domain = "mydadleft.me";
    hostName = "atlas";
    firewall.allowedTCPPorts = [config.services.prometheus.exporters.node.port];
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
