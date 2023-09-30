{lib, ...}: {
  default = final: prev: (lib.composeManyExtensions [
      (import ./_btop.nix)
      (import ./_discord.nix)
      (import ./_fish.nix)
      (import ./_neovim.nix)
    ]
    final
    prev);
}
