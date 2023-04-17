{lib}: let
  inherit (builtins) readDir;
  inherit (lib) filterAttrs mapAttrs;

  my = {
    mapFilterDirs = dir: filter: map: let
      dirs = filterAttrs filter (readDir dir);
    in
      mapAttrs map dirs;
  };

  myLib = lib.extend (_: _: {inherit my;});
  common = {lib = myLib;};
in
  (import ./host.nix common)
  // (import ./user.nix common)
