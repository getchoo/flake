{
  lib,
  inputs,
  ...
}: rec {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  genSystems = lib.genAttrs systems;
  nixpkgsFor = genSystems (sys: inputs.nixpkgs.legacyPackages.${sys});
  forAllSystems = fn: genSystems (sys: fn nixpkgsFor.${sys});

  getSystem = pkgs: pkgs.stdenv.hostPlatform.system;
}
