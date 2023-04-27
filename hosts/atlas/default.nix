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
        "https://getchoo.cachix.org"
        "https://nix-community.cachix.org"
        "https://hercules-ci.cachix.org"
        "https://wurzelpfropf.cachix.org"
      ];

      trusted-public-keys = [
        "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
        "wurzelpfropf.cachix.org-1:ilZwK5a6wJqVr7Fyrzp4blIEkGK+LJT0QrpWr1qBNq0="
      ];
    };
  };

  services = {
    hercules-ci-agent.enable = true;
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
