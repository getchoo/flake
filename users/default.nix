{ withSystem, ... }:

{
  configurations.home = {
    seth = {
      modules = [ ./seth/home.nix ];
      pkgs = withSystem "x86_64-linux" ({ pkgs, ... }: pkgs);
    };
  };
}
