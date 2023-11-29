{
  flake.overlays.default = final: prev:
    prev.lib.composeManyExtensions
    (
      prev.lib.pipe ./. [
        builtins.readDir
        (prev.lib.filterAttrs (n: _: n != "default.nix"))
        (prev.lib.mapAttrsToList (f: _: import ./${f}))
      ]
    )
    final
    prev;
}
