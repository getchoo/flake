{lib, ...} @ args: {
  flake.lib =
    (lib.extend (final: prev: {
      my = import ./lib.nix args;
    }))
    .my;
}
