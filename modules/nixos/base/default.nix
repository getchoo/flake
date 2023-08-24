{
  config,
  lib,
  ...
}: let
  cfg = config.base;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.base.enable = mkEnableOption "base nixos module";

  imports = [
    ../../shared
    ./documentation.nix
    ./locale.nix
    ./network.nix
    ./packages.nix
    ./root.nix
    ./security.nix
    ./systemd.nix
    ./upgrade-diff.nix
  ];

  config = mkIf cfg.enable {
    base = {
      defaultPackages.enable = mkDefault true;
      defaultLocale.enable = mkDefault true;
      defaultRoot.enable = mkDefault true;
      documentation.enable = mkDefault true;
      networking.enable = mkDefault true;
      nix-settings.enable = mkDefault true;
    };
  };
}
