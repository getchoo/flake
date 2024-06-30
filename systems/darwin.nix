{ self, ... }:
{
  flake = {
    darwinConfigurations =
      let
        inherit (self.lib) darwinSystem;
      in
      {
        caroline = darwinSystem { modules = [ ./caroline ]; };
      };
  };
}
