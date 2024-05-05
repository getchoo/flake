{
  config,
  lib,
  ...
}: let
  cfg = config.seth.programs.mangohud;
in {
  options.seth.programs.mangohud = {
    enable =
      lib.mkEnableOption "MangoHud configuration"
      // {
        default = config.seth.desktop.enable;
      };
  };

  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      settings = {
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
