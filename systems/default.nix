{
  inputs,
  self,
  ...
}: {
  configurations = {
    darwin = {
      caroline = {
        modules = [./caroline];
      };
    };

    nixos = let
      stable = inputs.nixpkgs-stable.lib.nixosSystem;
    in {
      glados = {
        modules = [./glados];
      };

      glados-wsl = {
        modules = [./glados-wsl];
      };

      atlas = {
        builder = stable;
        modules = [./atlas];
        system = "aarch64-linux";
      };
    };
  };

  perSystem = {system, ...}: {
    apps = (inputs.nixinate.nixinate.${system} self).nixinate;
  };
}
