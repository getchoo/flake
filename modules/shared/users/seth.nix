{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.users.seth;
in {
  options.users.seth = {
    enable = lib.mkEnableOption "Seth's configuration & home";
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
        hashedPasswordFile = lib.mkDefault config.age.secrets.sethPassword.path;
      };

    programs.fish.enable = lib.mkDefault true;

    home-manager.users.seth = {
      imports = [../../../users/seth];
    };
  };
}
