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
  nix.settings.trusted-users = ["atlas"];

  services.hercules-ci-agent.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
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
