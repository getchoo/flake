{
  inputs,
  self,
  ...
}: let
  inherit (self.lib.configs) mapHMUsers genHMModules;
  users = import ./users.nix inputs;
in {
  perSystem = {system, ...}: {
    homeConfigurations = mapHMUsers (users system);
  };

  flake = {
    homeManagerModules = genHMModules (users "x86_64-linux");
  };
}
