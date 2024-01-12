{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.nvk;
  mesa = import ./mesa.nix pkgs;
  mesa32 = import ./mesa.nix pkgs.pkgsi686Linux;
in {
  options.features.nvk.enable = lib.mkEnableOption "nvk";

  config = lib.mkIf cfg.enable {
    hardware.opengl = {
      package = mesa.drivers;
      package32 = mesa32.drivers;
    };

    system.replaceRuntimeDependencies = [
      {
        original = pkgs.mesa;
        replacement = mesa;
      }
      {
        original = pkgs.mesa.drivers;
        replacement = mesa.drivers;
      }
      {
        original = pkgs.pkgsi686Linux.mesa;
        replacement = mesa32;
      }
      {
        original = pkgs.pkgsi686Linux.mesa.drivers;
        replacement = mesa32.drivers;
      }
    ];
  };
}
