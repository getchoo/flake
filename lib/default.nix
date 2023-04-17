{lib}: let
  inherit (builtins) readDir;
  inherit (lib) filterAttrs mapAttrs;

  mapFilterDirs = dir: filter: map: let
    dirs = filterAttrs filter (readDir dir);
  in
    mapAttrs map dirs;
in
  (import ./host.nix {inherit mapFilterDirs;})
  // (import ./user.nix {inherit mapFilterDirs;})
