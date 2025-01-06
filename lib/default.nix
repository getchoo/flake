{ lib, ... }:

{
  flake.lib = lib.makeExtensible (
    final:

    lib.mapAttrs (lib.const (lib.flip import { inherit lib final; })) {
      nginx = ./nginx.nix;
    }
  );
}
