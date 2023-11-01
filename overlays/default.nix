{
  flake.overlays.default = final: prev:
    prev.lib.composeManyExtensions
    (
      let
        files = prev.lib.filterAttrs (n: _: n != "default.nix") (builtins.readDir ./.);
      in
        prev.lib.mapAttrsToList (n: _: import ./${n}) files
    )
    final
    prev;
}
