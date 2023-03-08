{
  inputs,
  lib,
}: let
  mapFilterDirs = dir: filter: map:
    with builtins;
    with lib; let
      dirs = filterAttrs filter (readDir dir);
    in
      mapAttrs map dirs;
in {
  host = import ./host.nix {inherit lib inputs mapFilterDirs;};
  user = import ./user.nix {inherit lib inputs mapFilterDirs;};
}
