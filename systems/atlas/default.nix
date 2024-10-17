{ modulesPath, inputs, ... }:
{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ./hardware-configuration.nix
    ./miniflux.nix
    ./nginx.nix
    ./nixpkgs-tracker-bot.nix
    ./teawiebot.nix

    inputs.self.nixosModules.default
  ];

  archetypes.server.enable = true;
  base.networking.enable = false;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    domain = "getchoo.com";
    hostName = "atlas";
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  services = {
    github-mirror = {
      enable = true;
      hostname = "git.getchoo.com";
      mirroredUsers = [
        "getchoo"
        "getchoo-archive"
      ];
    };
  };

  system.stateVersion = "23.05";
}
