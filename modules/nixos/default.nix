{
  config,
  lib,
  ...
}: let
  cfg = config.nixos;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.nixos.enable = mkEnableOption "base nixos module";

  imports = [
    ./locale.nix
    ./network.nix
    ./root.nix
    ./security.nix
    ./systemd.nix
    ./virtualisation.nix
  ];

  config = mkIf cfg.enable {
    base.enable = true;
    nixos = {
      defaultLocale.enable = mkDefault true;
      defaultRoot.enable = mkDefault true;
      networking.enable = mkDefault true;
    };
  };
}
