{ self, ... }:
{
  flake = {
    nixosConfigurations =
      let
        # see ./lib/builders.nix
        inherit (self.lib) nixosSystem nixosSystemStable;
      in
      {
        glados = nixosSystem { modules = [ ./glados ]; };

        glados-wsl = nixosSystem { modules = [ ./glados-wsl ]; };

        atlas = nixosSystemStable { modules = [ ./atlas ]; };
      };
  };
}
