{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.traits.users.seth;
in
{
  options.traits.users.seth = {
    enable = lib.mkEnableOption "Seth's user & home configurations";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      users.users.seth.shell = pkgs.fish;

      programs.fish.enable = true;

      home-manager.users.seth = {
        imports = [ (inputs.self + "/users/seth") ];
        seth = {
          enable = true;
          programs.fish.enable = true;
        };
      };
    })

    (lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
      users.users.seth = {
        home = lib.mkDefault "/Users/seth";
      };
    })

    (lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
      users.users.seth = {
        extraGroups = [ "wheel" ];
        isNormalUser = true;
      };
    })
  ];
}
