{ self, ... }:
{
  flake = {
    nixosConfigurations =
      let
        inherit (self.lib) nixosSystem nixosSystemStable;
      in
      {
        glados = nixosSystem { modules = [ ./glados ]; };

        glados-wsl = nixosSystem { modules = [ ./glados-wsl ]; };

        atlas = nixosSystemStable { modules = [ ./atlas ]; };
      };
  };
}
