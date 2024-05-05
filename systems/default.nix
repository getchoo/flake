{
  inputs,
  self,
  ...
}: {
  flake = {
    darwinConfigurations = let
      builder = inputs.darwin.lib.darwinSystem;
    in
      self.lib.configs.mapDarwin {
        caroline = {
          inherit builder;
          system = "x86_64-darwin";
        };
      };

    deploy = {
      remoteBuild = true;
      fastConnection = false;
      nodes = self.lib.deploy.mapNodes [
        "atlas"
      ];
    };

    nixosConfigurations = let
      unstable = inputs.nixpkgs.lib.nixosSystem;
      stable = inputs.nixpkgs-stable.lib.nixosSystem;
    in
      self.lib.configs.mapNixOS {
        glados = {
          builder = unstable;
          system = "x86_64-linux";
        };

        glados-wsl = {
          builder = unstable;
          system = "x86_64-linux";
        };

        atlas = {
          builder = stable;
          system = "aarch64-linux";
        };
      };
  };
}
