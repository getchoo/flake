{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.seth.shell.fish;
in
{
  options.seth.shell.fish = {
    enable = lib.mkEnableOption "Fish configuration";
    withPlugins = lib.mkEnableOption "Fish plugins" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = lib.mkMerge [
      {
        enable = true;

        interactiveShellInit =
          ''
            ${lib.getExe pkgs.nix-your-shell} fish | source
          ''
          # TODO: do i still need this weird sourcing?
          + lib.optionalString config.seth.standalone.enable ''
            set -l nixfile ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.fish
            if test -e $nixfile
            	source $nixfile
            end
          '';

        functions = {
          last_history_item.body = "echo $history[1]";
        };

        shellAbbrs = {
          nixgc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
          "!!" = {
            position = "anywhere";
            function = "last_history_item";
          };
        };
      }

      (lib.mkIf cfg.withPlugins {
        plugins =
          let
            mkFishPlugins = map (plugin: {
              name = plugin;
              inherit (pkgs.fishPlugins.${plugin}) src;
            });
          in
          mkFishPlugins [ "autopair" ];
      })
    ];
  };
}
