{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  _module.args.nixinate = {
    host = "164.152.17.183";
    sshUser = "root";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  boot = {
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.hostName = "atlas";
  system.stateVersion = "22.11";

  users.users = let
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMPV9wiDwXVyoVh347CAulkdGzG7+1m/rZ1aV5fk3BHM atlas getchoo@tuta.io"
    ];
  in {
    root = {inherit openssh;};
    atlas = {
      extraGroups = ["wheel"];
      isNormalUser = true;
      shell = pkgs.bash;
      passwordFile = config.age.secrets.userPassword.path;
      inherit openssh;
    };
  };

  zramSwap.enable = true;
}
