{
  lib,
  inputs,
  ...
}: let
  inherit (lib.my) utils;
in {
  attrsFor = system: lib.mapAttrs (lib.const (val: val.${system} or val));
  inputsFor = system: lib.mapAttrs (lib.const (utils.attrsFor system)) inputs;
}
