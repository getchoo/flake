{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.users.seth;
in {
  options.traits.users.seth = {
    enable = lib.mkEnableOption "Seth's user & home configuration";
  };

  config = lib.mkIf cfg.enable {
    users.users.seth =
      {
        shell = pkgs.fish;
        home = lib.mkDefault (
          if pkgs.stdenv.isDarwin
          then "/Users/seth"
          else "/home/seth"
        );
      }
      // lib.optionalAttrs pkgs.stdenv.isLinux {
        extraGroups = ["wheel"];
        isNormalUser = true;
      };

    programs.fish.enable = lib.mkDefault true;

    home-manager.users.seth = {
      imports = [./.];
    };
  };
}
