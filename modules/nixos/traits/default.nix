{
  imports = [
    ./24.05-compat.nix # TODO: remove when 24.11 is stable

    ./auto-upgrade.nix
    ./containers.nix
    ./home-manager.nix
    ./locale.nix
    ./nvidia.nix
    ./secrets.nix
    ./tailscale.nix
    ./users
    ./zram.nix
  ];
}
