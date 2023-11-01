{
  config,
  pkgs,
  inputs,
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

  nixpkgs.overlays = with inputs; [nur.overlay getchoo.overlays.default self.overlays.default];
}
