{
  inputs,
  self,
}: let
  common = {
    nixpkgs = {
      overlays = with inputs; [nur.overlay getchoo.overlays.default self.overlays.default];
      config.allowUnfree = true;
    };

    nix = {
      registry =
        {
          n.flake = inputs.nixpkgs;
        }
        // (builtins.mapAttrs (_: flake: {inherit flake;})
          (inputs.nixpkgs.lib.filterAttrs (n: _: n != "nixpkgs") inputs));

      settings = {
        trusted-substituters = [
          "https://getchoo.cachix.org"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
  };

  specialArgs = inputs // {inherit inputs;};
in {
  personal = {
    system = "x86_64-linux";
    builder = inputs.nixpkgs.lib.nixosSystem;
    inherit specialArgs;

    modules = with inputs; [
      common
      ragenix.nixosModules.default
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur

      self.nixosModules.default
      ../users/seth

      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = let
            baseDir = "${self}/secrets/shared";
          in {
            rootPassword.file = "${baseDir}/rootPassword.age";
            sethPassword.file = "${baseDir}/sethPassword.age";
          };
        };

        base.enable = true;
        system.stateVersion = "23.11";
      }
    ];
  };

  personal-darwin = {
    builder = inputs.darwin.lib.darwinSystem;
    inherit specialArgs;
    modules = with inputs; [
      common
      home-manager.darwinModules.home-manager

      ../users/seth
      self.darwinModules.default

      {
        base.enable = true;
        desktop.enable = true;
        system.stateVersion = 4;

        home-manager.users.seth = {
          imports = [
            ../users/seth/darwin.nix
          ];

          getchoo.desktop.enable = false;
        };
      }
    ];
  };

  server = {
    builder = inputs.nixpkgs-stable.lib.nixosSystem;
    inherit specialArgs;

    modules = with inputs; [
      ragenix.nixosModules.default
      ../modules/nixos/base
      ../modules/nixos/server
      ../modules/nixos/features/tailscale.nix

      {
        features.tailscale = {
          enable = true;
          ssh.enable = true;
        };

        server = {
          enable = true;
          secrets.enable = true;
          services = {
            hercules-ci = {
              enable = true;
              secrets.enable = true;
            };

            promtail = {
              enable = true;
              clients = [
                {
                  url = "http://p-body:3030/loki/api/v1/push";
                }
              ];
            };
          };
        };

        services.prometheus.exporters.node = {
          enable = true;
          enabledCollectors = ["systemd"];
        };

        nix.registry.nixpkgs.flake = nixpkgs-stable;
        system.stateVersion = "23.05";
      }
    ];
  };
}
