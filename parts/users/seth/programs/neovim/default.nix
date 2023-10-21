{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.getchoo.programs.neovim;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.programs.neovim.enable = mkEnableOption "neovim" // {default = true;};

  config = mkIf cfg.enable {
    home.packages = [
      inputs.getchvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
