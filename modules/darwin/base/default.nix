{
  config,
  lib,
  ...
}: let
  cfg = config.base;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.base.enable = mkEnableOption "base darwin module";

  imports = [
    ../../shared
    ./nix.nix
    ./packages.nix
  ];

  config = mkIf cfg.enable {
    base = {
      defaultPackages.enable = mkDefault true;
      defaultLocale.enable = mkDefault true;
      documentation.enable = mkDefault true;
      nix-settings.enable = mkDefault true;
    };
  };
}
