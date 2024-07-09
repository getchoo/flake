{ self, ... }:
{
  flake = {
    darwinConfigurations =
      let
        # see ./lib/builders.nix
        inherit (self.lib) darwinSystem;
      in
      {
        caroline = darwinSystem { modules = [ ./caroline ]; };
      };
  };
}
