{
  inputs,
  self,
}: let
  hmSetup = {
    imports = [
      ../users/seth/system.nix
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs self;};
    };
  };
in {
  nixos =
    (with inputs; [
      agenix.nixosModules.default
      catppuccin.nixosModules.catppuccin
      hm.nixosModules.home-manager
      nur.nixosModules.nur
    ])
    ++ [
      self.nixosModules.default
      self.nixosModules.hardware
      self.nixosModules.features

      hmSetup

      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = let
            baseDir = ../secrets/shared;
          in {
            rootPassword.file = "${baseDir}/rootPassword.age";
            sethPassword.file = "${baseDir}/sethPassword.age";
          };
        };

        system.stateVersion = "23.11";
      }
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
