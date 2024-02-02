{
  config,
  lib,
  pkgs,
  ...
}: let
  fromINI = file: let
    json = pkgs.runCommand "converted.json" {} ''
      ${lib.getExe pkgs.jc} --init < ${file} > $out
    '';
  in
    lib.importJSON json;

  theme = pkgs.fetchFromGithub {
    owner = "tetov";
    repo = "ctp-fuzzel";
    rev = "9fd3243d830b44a484f7e32719545fc14992237c";
    hash = "sha256-oDyGlJG8YKwUIbHKPyArvUAcnbx1GRBZ98641JUhrpQ=";
  };
in {
  programs.fuzzel = {
    enable = true;

    settings = {
      inherit (fromINI (theme + "/themes/mocha.ini")) colors;

      main = {
        font = "Noto Sans=11";
        terminal = lib.getExe config.programs.wezterm.package;
      };
    };
  };

  wayland.windowManager.sway.config.menu = lib.getExe config.programs.fuzzel.package;
}
