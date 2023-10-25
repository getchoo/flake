{
  inputs,
  self,
  ...
}: let
  specialArgs = {inherit inputs self;};
in {
  personal = {
    system = "x86_64-linux";
    builder = inputs.nixpkgs.lib.nixosSystem;
    inherit specialArgs;

    modules = with inputs; [
      agenix.nixosModules.default
      catppuccin.nixosModules.catppuccin
      hm.nixosModules.home-manager
      nur.nixosModules.nur
      self.nixosModules.default

      ../users/seth/system.nix

      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = let
            baseDir = "${self}/parts/secrets/shared";
          in {
            rootPassword.file = "${baseDir}/rootPassword.age";
            sethPassword.file = "${baseDir}/sethPassword.age";
          };
        };

        base.enable = true;
        system.stateVersion = "23.11";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
        };
      }
    ];
  };

  personal-darwin = {
    builder = inputs.darwin.lib.darwinSystem;
    inherit specialArgs;
    modules = with inputs; [
      hm.darwinModules.home-manager
      self.darwinModules.default

      ../users/seth/system.nix

      {
        base.enable = true;
        desktop.enable = true;
        system.stateVersion = 4;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;

          users.seth = {
            imports = [
              ../users/seth/darwin.nix
            ];

            getchoo.desktop.enable = false;
          };
        };
      }
    ];
  };

  server = {
    builder = inputs.nixpkgs-stable.lib.nixosSystem;
    inherit specialArgs;

    modules = with inputs; [
      agenix.nixosModules.default
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
        };

        nix.registry.n.flake = nixpkgs-stable;
        system.stateVersion = "23.05";
      }
    ];
  };
}
