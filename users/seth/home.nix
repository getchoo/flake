{desktop, ...}: let
  usingDesktop = desktop != "";
in {
  imports =
    [
      ./programs
      ./shell
    ]
    ++ (
      if usingDesktop
      then [./desktop]
      else []
    );

  nix.settings.warn-dirty = false;
}
