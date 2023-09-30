{
  inputs,
  self',
  ...
}: let
  specialArgs = inputs // {inherit inputs;};
in {
  personal = {
    system = "x86_64-linux";
    builder = inputs.nixpkgs.lib.nixosSystem;
    inherit specialArgs;

    modules = with inputs; [
      agenix.nixosModules.default
      hm.nixosModules.home-manager
      nur.nixosModules.nur

      self'.nixosModules.default
      ./nixosModules/features/tailscale.nix
      ./homeConfigurations/_seth/system.nix

      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = let
            baseDir = "${self'}/src/_secrets/shared";
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
      hm.darwinModules.home-manager

      ./homeConfigurations/_seth/system.nix
      self'.darwinModules.default

      {
        base.enable = true;
        desktop.enable = true;
        system.stateVersion = 4;

        home-manager.users.seth = {
          imports = [
            ../homeConfigurations/_seth/darwin.nix
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
      agenix.nixosModules.default
      ./nixosModules/base
      ./nixosModules/server
      ./nixosModules/features/tailscale.nix

      {
        features.tailscale = {
          enable = true;
          ssh.enable = true;
        };

        server = {
          enable = true;
          secrets.enable = true;
        };

        nix.registry.n.flake = nixpkgs-stable;
        system.stateVersion = "23.05";
      }
    ];
  };
}
