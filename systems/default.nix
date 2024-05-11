{
  inputs,
  self,
  ...
}: {
  darwinConfigurations = {
    caroline = {
      system = "x86_64-darwin";
    };
  };

  nixosConfigurations = let
    stable = inputs.nixpkgs-stable.lib.nixosSystem;
  in {
    glados = {
      system = "x86_64-linux";
    };

    glados-wsl = {
      system = "x86_64-linux";
    };

    atlas = {
      builder = stable;
      system = "aarch64-linux";
    };
  };

  perSystem = {system, ...}: {
    apps = (inputs.nixinate.nixinate.${system} self).nixinate;
  };
}
