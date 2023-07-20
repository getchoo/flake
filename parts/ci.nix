{
  lib,
  myLib,
  self,
  ...
}: let
  ciSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  mkChecks = sys: let
    ci = myLib.ci [sys];
  in
    lib.recursiveUpdate
    (ci.mkCompatibleHM self.homeConfigurations).${sys}
    (ci.mkCompatibleCfg self.nixosConfigurations);
in {
  flake = {
    checks =
      lib.genAttrs ciSystems mkChecks;
  };
}
