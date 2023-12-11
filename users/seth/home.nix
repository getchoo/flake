{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [./.];

  home = {
    username = "seth";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${config.home.username}"
      else "/home/${config.home.username}";
  };

  nixpkgs.overlays = [self.overlays.default];
}
