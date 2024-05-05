{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.seth.shell.fish;
in {
  options.seth.shell.fish = {
    enable = lib.mkEnableOption "Fish configuration" // {default = config.seth.enable;};
    withPlugins = lib.mkEnableOption "Fish plugins" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.fish = lib.mkMerge [
      {
        enable = true;
        catppuccin.enable = true;

        interactiveShellInit = ''
          set -l nixfile ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.fish
          if test -e $nixfile
          	source $nixfile
          end

          ${lib.getExe pkgs.nix-your-shell} fish | source

          abbr -a !! --position anywhere --function last_history_item
        '';

        functions = {
          last_history_item.body = "echo $history[1]";
        };

        shellAbbrs = {
          nixgc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
        };
      }

      (lib.mkIf cfg.withPlugins {
        plugins = let
          mkFishPlugins = builtins.map (plugin: {
            name = plugin;
            inherit (pkgs.fishPlugins.${plugin}) src;
          });
        in
          mkFishPlugins [
            "autopair"
          ];
      })
    ];
  };
}
