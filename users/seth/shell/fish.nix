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
    '';
    plugins = [
      {
        name = "autopair-fish";
        src = pkgs.fishPlugins.autopair-fish;
      }

      {
        name = "puffer-fish";
        src = pkgs.fetchFromGitHub {
          owner = "nickeb96";
          repo = "puffer-fish";
          rev = "fd0a9c95da59512beffddb3df95e64221f894631";
          sha256 = "sha256-aij48yQHeAKCoAD43rGhqW8X/qmEGGkg8B4jSeqjVU0=";
        };
      }
    ];
  };
}
