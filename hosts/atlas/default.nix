{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./cachix.nix
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
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  getchoo.server = {
    secrets.enable = true;
  };

  networking = {
    domain = "mydadleft.me";
    hostName = "atlas";
  };

  nix.settings.trusted-users = ["bob"];

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
    bob = {
      isNormalUser = true;
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtbxHjDADxqsG+AgCoiDq0uCsgcnJCIH+9rB6K5pIi9 p-body@p-body"
        "ssh-ed25519 aaaac3nzac1lzdi1nte5aaaaimpv9widwxvyovh347caulkdgzg7+1m/rz1av5fk3bhm atlas getchoo@tuta.io"
      ];
    };
  };

  zramSwap.enable = true;
}
