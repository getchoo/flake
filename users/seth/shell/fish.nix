{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."fish/themes" = {
    recursive = true;
    source =
      pkgs.fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "fish";
        rev = "b90966686068b5ebc9f80e5b90fdf8c02ee7a0ba";
        sha256 = "sha256-wQlYQyqklU/79K2OXRZXg5LvuIugK7vhHgpahpLFaOw=";
      }
      + "/themes";
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -l nixfile ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.fish
      if test -e $nixfile
      	source $nixfile
      end

      fish_config theme choose "Catppuccin Mocha"
      nix-your-shell fish | source

      abbr -a !! --position anywhere --function last_history_item
    '';

    functions = {
      last_history_item.body = "echo $history[1]";
    };

    plugins = let
      mkFishPlugins = builtins.map (plugin: {
        name = plugin;
        inherit (pkgs.fishPlugins.${plugin}) src;
      });
    in
      mkFishPlugins [
        "autopair"
      ];
  };
}
