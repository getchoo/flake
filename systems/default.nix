{
  inputs,
  self,
  ...
}: {
  flake = {
    darwinConfigurations = let
      inherit (self.lib) darwinSystem;
    in {
      caroline = darwinSystem {
        modules = [./caroline];
      };
    };

    nixosConfigurations = let
      inherit (self.lib) nixosSystem nixosSystemStable;
    in {
      glados = nixosSystem {
        modules = [./glados];
      };

      glados-wsl = nixosSystem {
        modules = [./glados-wsl];
      };

      atlas = nixosSystemStable {
        modules = [./atlas];
      };
    };
  };

  perSystem = {system, ...}: {
    apps = (inputs.nixinate.nixinate.${system} self).nixinate;
  };
}
