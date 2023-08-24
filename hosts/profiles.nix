{
  inputs,
  self,
}: let
  specialArgs = inputs // {inherit inputs;};
in {
  personal = {
    system = "x86_64-linux";
    builder = inputs.nixpkgs.lib.nixosSystem;
    inherit specialArgs;

    modules = with inputs; [
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

        nix.registry.n.flake = nixpkgs-stable;
        system.stateVersion = "23.05";
      }
    ];
  };
}
