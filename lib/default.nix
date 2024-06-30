{
  lib,
  self,
  inputs,
  ...
}:
{
  flake.lib =
    (lib.extend (
      final: _: {
        my = import ./lib.nix {
          inherit self inputs;
          lib = final;
        };
      }
    )).my;
}
