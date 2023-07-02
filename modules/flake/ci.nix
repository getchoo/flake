{
  inputs,
  myLib,
  self,
  ...
}: let
  ciSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  ci = sys: myLib.ci ["${sys}"];
  hm = sys: (ci sys).mkCompatibleHM self.homeConfigurations;
  hosts = sys: (ci sys).mkCompatibleCfg self.nixosConfigurations;
in {
  flake = {
    checks = inputs.nixpkgs.lib.genAttrs ciSystems hosts;
  };

  perSystem = {system, ...}: {
    checks = (hm system).${system};
  };
}
