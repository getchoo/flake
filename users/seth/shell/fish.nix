{ pkgs, ... }: {
  programs.fish = {
    enable = true;
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
