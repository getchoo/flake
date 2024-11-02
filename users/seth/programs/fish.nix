{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.seth.programs.fish;
in
{
  options.seth.programs.fish = {
    enable = lib.mkEnableOption "Fish configuration";
    withPlugins = lib.mkEnableOption "Fish plugins" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.fish = {
          enable = true;

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
        };
      }

      # TODO: do i still need this weird sourcing?
      (lib.mkIf config.seth.standalone.enable {
        programs.fish = {
          interactiveShellInit = ''
            set -l nixfile ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.fish
            if test -e $nixfile
            	source $nixfile
            end
          '';
        };
      })

      (lib.mkIf cfg.withPlugins {
        programs.fish = {
          plugins =
            let
              useFishPlugins = map (plugin: {
                name = plugin;
                inherit (pkgs.fishPlugins.${plugin}) src;
              });
            in
            useFishPlugins [ "autopair" ];
        };
      })
    ]
  );
}
