{
  lib,
  inputs,
  ...
}: {
  flake.lib =
    (
      lib.extend (final: prev: let
        readDir' = dir:
          prev.filterAttrs (name: (
            prev.const (name != "default.nix")
          )) (builtins.readDir dir);
      in {
        my =
          prev.recursiveUpdate
          (
            prev.mapAttrs' (name: (
              prev.const (
                prev.nameValuePair
                (prev.removeSuffix ".nix" name)
                (import ./${name} {
                  lib = final;
                  inherit inputs;
                })
              )
            )) (readDir' ./.)
          )
          {
            inherit readDir';
          };
      })
    )
    .my;
}
