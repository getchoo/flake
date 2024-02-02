{
  inputs,
  self,
}: let
  hmSetup = {inputs', ...}: {
    imports = [
      ../users/seth/system.nix
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs inputs' self;};
    };
  };

  nixosModules = builtins.attrValues self.nixosModules;
  darwinModules = builtins.attrValues self.darwinModules;
in {
  personal =
    nixosModules
    ++ [
      inputs.agenix.nixosModules.default
      inputs.catppuccin.nixosModules.catppuccin
      inputs.hm.nixosModules.home-manager

      hmSetup

      ({secretsDir, ...}: {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = secretsDir + "/rootPassword.age";
            sethPassword.file = secretsDir + "/sethPassword.age";
          };
        };

        services.nixseparatedebuginfod.enable = true;
      })
    ];

  darwin =
    darwinModules
    ++ [
      inputs.hm.darwinModules.home-manager
      hmSetup

      {
        desktop.enable = true;
      }
    ];

  server =
    nixosModules
    ++ [
      inputs.agenix.nixosModules.default

      {
        features.tailscale = {
          enable = true;
          ssh.enable = true;
        };

        server = {
          enable = true;
          secrets.enable = true;
        };

        nix.registry.n.flake = inputs.nixpkgs-stable;
        environment.etc."nix/inputs/nixpkgs".source = inputs.nixpkgs-stable.outPath;
      }
    ];
}
