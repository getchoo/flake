{lib, ...} @ args: {
  flake.lib =
    (lib.extend (final: _: {
      my = import ./lib.nix (args // {lib = final;});
    }))
    .my;
}
