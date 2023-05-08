{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.base;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.base.enable = mkEnableOption "base nixos module";

  imports = [
    ./documentation.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./packages.nix
    ./root.nix
    ./security.nix
    ./systemd.nix
    ./virtualisation.nix
  ];

  config = mkIf cfg.enable {
    getchoo.base = {
      defaultPackages.enable = mkDefault true;
      defaultLocale.enable = mkDefault true;
      defaultRoot.enable = mkDefault true;
      documentation.enable = mkDefault true;
      networking.enable = mkDefault true;
      nix-settings.enable = mkDefault true;
    };
  };
}
