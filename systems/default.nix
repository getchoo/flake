{
  inputs,
  self,
  ...
}: {
  configurations = {
    nixos = {
      builder = inputs.nixpkgs.lib.nixosSystem;

      modules = [
        inputs.agenix.nixosModules.default
        inputs.hm.nixosModules.home-manager
      ];

      systems = {
        glados = {};

        glados-wsl = {};

        atlas = {
          builder = inputs.nixpkgs-stable.lib.nixosSystem;
          system = "aarch64-linux";
        };
      };
    };

    darwin = {
      builder = inputs.darwin.lib.darwinSystem;

      modules = [
        inputs.hm.darwinModules.home-manager
      ];

      systems = {
        caroline = {};
      };
    };
  };

  flake.deploy = {
    remoteBuild = true;
    fastConnection = false;
    nodes = self.lib.deploy.mapNodes [
      "atlas"
    ];
  };
}
