{ config, lib, ... }:
let
  cfg = config.profiles.personal;
in
{
  options.profiles.personal = {
    enable = lib.mkEnableOption "the Personal profile";
  };

  config = lib.mkIf cfg.enable {
    desktop.enable = true;

    traits = {
      home-manager.enable = true;
      users = {
        seth.enable = true;
      };
    };
  };
}
