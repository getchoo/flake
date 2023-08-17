{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.programs.mangohud;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.programs.mangohud.enable =
    mkEnableOption "mangohud"
    // {default = config.getchoo.desktop.enable;};

  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        legacy_layout = false;
        cpu_stats = true;
        cpu_temp = true;
        gpu_stats = true;
        gpu_temp = true;
        fps = true;
        frametime = true;
        media_player = true;
        media_player_name = "spotify";
      };
    };
  };
}
