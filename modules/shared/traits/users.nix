{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.users;
in {
  options.traits.users = {
    seth = {
      enable = lib.mkEnableOption "Seth's user & home configurations";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.seth.enable {
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
        imports = [../../../users/seth];
        seth.enable = true;
      };
    })
  ];
}
