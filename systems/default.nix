{
  inputs,
  self,
  ...
}: let
  nixos-stable = inputs.nixpkgs-stable.lib.nixosSystem;
in {
  nixosConfigurations = {
    glados = {
      system = "x86_64-linux";
    };

    glados-wsl = {
      system = "x86_64-linux";
    };

    atlas = {
      builder = nixos-stable;
      system = "aarch64-linux";
    };
  };

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
}
