# collection of fun workarounds for the stable branch of nixos
{ lib, ... }:
{
  imports = lib.optionals (lib.versionOlder lib.version "24.11pre") [
    # https://github.com/NixOS/nixpkgs/pull/320228
    (lib.mkAliasOptionModule
      [
        "hardware"
        "graphics"
        "extraPackages"
      ]
      [
        "hardware"
        "opengl"
        "extraPackages"
      ]
    )
  ];
}
