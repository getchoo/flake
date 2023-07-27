{lib, ...}: {
  flake.overlays.default = lib.composeManyExtensions [
    (import ./btop.nix)
    (import ./discord.nix)
    (import ./fish.nix)
    (import ./neovim.nix)
  ];
}
