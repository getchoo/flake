{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [mangohud];

    xdg.configFile."MangoHud/MangoHud.conf" = {
      text = ''
        legacy_layout=false
        cpu_stats
        cpu_temp
        gpu_stats
        gpu_temp
        fps
        frametime
        media_player
        media_player_name = spotify
      '';
    };
  };
}
