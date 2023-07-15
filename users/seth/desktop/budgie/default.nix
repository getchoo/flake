{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.budgie;
  inherit (lib) mkEnableOption mkIf;
  fromYaml = file: let
    json = with pkgs;
      runCommand "converted.json" {} ''
        ${yj}/bin/yj < ${file} > $out
      '';
  in
    with builtins; fromJSON (readFile json);
in {
  options.desktop.budgie.enable = mkEnableOption "enable budgie";

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = let
        file =
          pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "alacritty";
            rev = "3c808cbb4f9c87be43ba5241bc57373c793d2f17";
            sha256 = "sha256-w9XVtEe7TqzxxGUCDUR9BFkzLZjG8XrplXJ3lX6f+x0=";
          }
          + "/catppuccin-mocha.yml";
      in
        (fromYaml file)
        // {
        };
    };

    dconf = {
      enable = true;
      settings = {
        "com.solus-project.budgie-panel:Budgie" = {
          pinned-launchers = ["firefox.desktop" "nemo.desktop" "discord.desktop"];
        };
      };
    };
  };
}
