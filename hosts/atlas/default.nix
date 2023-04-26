{
  config,
  hercules-ci-agent,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    hercules-ci-agent.nixosModules.agent-service
  ];

  server.enable = true;

  boot.cleanTmpDir = true;

  environment.systemPackages = with pkgs; [
    hercules-ci-agent.packages.aarch64-linux.hercules-ci-cli
  ];

  networking.hostName = "atlas";
  nix = {
    settings = {
      trusted-users = ["atlas" "nix-ssh"];
      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://hercules-ci.cachix.org"
        "https://wurzelpfropf.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
        "wurzelpfropf.cachix.org-1:ilZwK5a6wJqVr7Fyrzp4blIEkGK+LJT0QrpWr1qBNq0="
      ];
    };

    sshServe = {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlNzPwEdNMT+wuW9pfYBQ7CSNUhBAF7rRXTRD4UIx9Z hercules-ci-agent@p-body"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+0oAgrDPVGl/SL54koypwWzMzjnVdqTm+QNkU2amF9 p-body@p-body"
      ];
    };
  };

  services = {
    hercules-ci-agent.enable = true;
    nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];

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
      passwordFile = config.age.secrets.atlasPassword.path;
      inherit openssh;
    };
  };

  zramSwap.enable = true;
}
