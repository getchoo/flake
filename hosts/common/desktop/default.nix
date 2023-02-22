{
  lib,
  desktop,
  ...
}: let
  gui = desktop != "";
in {
  imports =
    []
    ++ (
      if (desktop == "gnome")
      then [./gnome.nix]
      else []
    )
    ++ (
      if (desktop == "plasma")
      then [./plasma.nix]
      else []
    );

  environment.noXlibs = lib.mkForce false;
  programs.xwayland.enable = gui;
  services.xserver.enable = gui;
  xdg.portal.enable = gui;
}
