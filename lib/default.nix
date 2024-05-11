{lib, ...}: let
  fnsFrom = files:
    builtins.listToAttrs (
      map (file: {
        name = lib.removeSuffix ".nix" (baseNameOf file);
        value = import file lib;
      })
      files
    );
in {
  flake.lib = fnsFrom [
    ./nginx.nix
  ];
}
