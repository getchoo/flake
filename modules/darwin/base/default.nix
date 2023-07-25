{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.base;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.base.enable = mkEnableOption "base darwin module";

  imports = [
    ./documentation.nix
    ./locale.nix
    ./nix.nix
    ./packages.nix
  ];

  config = mkIf cfg.enable {
    getchoo.base = {
      defaultPackages.enable = mkDefault true;
      defaultLocale.enable = mkDefault true;
      documentation.enable = mkDefault true;
      nix-settings.enable = mkDefault true;
    };
  };
}
