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

  deploy = {
    remoteBuild = true;
    fastConnection = false;
    nodes = self.lib.deploy.mapNodes [
      "atlas"
    ];
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
}
