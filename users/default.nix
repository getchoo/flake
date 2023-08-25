{
  config,
  inputs,
  self,
  ...
}: let
  inherit (self.lib.configs) genHMUsers genHMModules;
  users = import ./users.nix inputs;
in {
  flake = {
    homeConfigurations = genHMUsers users config.systems;
    homeManagerModules = genHMModules (users "x86_64-linux");
  };
}
