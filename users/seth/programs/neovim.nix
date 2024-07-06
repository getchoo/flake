{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.seth.programs.neovim;
in
{
  options.seth.programs.neovim = {
    enable = lib.mkEnableOption "Neovim configuration" // {
      default = config.seth.enable;
      defaultText = lib.literalExpression "config.seth.enable";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (
        let
          getchvim = inputs.getchvim.packages.${pkgs.system}.default;
        in
        # remove desktop file
        pkgs.symlinkJoin {
          name = "${getchvim.name}-nodesktop";
          paths = [ getchvim ];
          postBuild = ''
            rm -rf $out/share/{applications,icons}
          '';
        }
      )
    ];
  };
}
