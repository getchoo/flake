{
  flake.overlays.default = final: prev:
    prev.lib.composeManyExtensions [
      (import ./btop.nix)
      (import ./discord.nix)
      (import ./fish.nix)
    ]
    final
    prev;
}
