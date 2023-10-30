{
  pkgs,
  inputs,
  ...
}: {
  imports = [./.];

  home = rec {
    username = "seth";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
  };

  nixpkgs.overlays = with inputs; [nur.overlay getchoo.overlays.default];
}
