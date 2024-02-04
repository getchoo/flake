{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.seth.programs.neovim;
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  options.seth.programs.neovim = {
    enable = lib.mkEnableOption "Neovim configuration" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (let
        getchvim = inputs.getchvim.packages.${system}.default;
      in
        # remove desktop file
        pkgs.symlinkJoin {
          name = "${getchvim.name}-nodesktop";
          paths = [getchvim];
          postBuild = ''
            rm -rf $out/share/{applications,icons}
          '';
        })
    ];
  };
}
