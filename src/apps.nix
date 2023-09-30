{
  self',
  nixinate,
  root,
  ...
}: let
  inherit (root.utils) forAllSystems getSystem;
in
  forAllSystems (
    pkgs:
      (nixinate.nixinate.${getSystem pkgs} self').nixinate
  )
