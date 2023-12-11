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
in {
  nixos =
    (with inputs; [
      agenix.nixosModules.default
      catppuccin.nixosModules.catppuccin
      hm.nixosModules.home-manager
    ])
    ++ [
      self.nixosModules.default
      self.nixosModules.features

      hmSetup

      ({secretsDir, ...}: {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = secretsDir + "/rootPassword.age";
            sethPassword.file = secretsDir + "/sethPassword.age";
          };
        };

        system.stateVersion = "23.11";
      })
    ];

  darwin = [
    inputs.hm.darwinModules.home-manager
    self.darwinModules.default
    self.darwinModules.desktop

    hmSetup

    {
      system.stateVersion = 4;
    }
  ];

  server = [
    inputs.agenix.nixosModules.default
    self.nixosModules.default
    self.nixosModules.features
    self.nixosModules.server
    self.nixosModules.services

    {
      features.tailscale = {
        enable = true;
        ssh.enable = true;
      };

      nix.registry.n.flake = inputs.nixpkgs-stable;
      system.stateVersion = "23.05";
    }
  ];
}
