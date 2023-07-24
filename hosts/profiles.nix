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
      registry = with inputs; {
        getchoo.flake = getchoo;
        nixpkgs.flake = nixpkgs;
      };

      settings = {
        trusted-substituters = [
          "https://getchoo.cachix.org"
          "https://cache.garnix.io"
          "https://nix-community.cachix.org"
          "https://wurzelpfropf.cachix.org"
        ];

        trusted-public-keys = [
          "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "wurzelpfropf.cachix.org-1:ilZwK5a6wJqVr7Fyrzp4blIEkGK+LJT0QrpWr1qBNq0="
        ];
      };
    };
  };
in {
  personal = {
    system = "x86_64-linux";
    builder = inputs.nixpkgs.lib.nixosSystem;

    modules = with inputs; [
      common
      ragenix.nixosModules.default
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur

      self.nixosModules.getchoo
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

        getchoo.base.enable = true;
        system.stateVersion = "23.11";
      }
    ];

    specialArgs = inputs;
  };

  personal-darwin = {
    builder = inputs.darwin.lib.darwinSystem;
    modules = with inputs; [
      common
      home-manager.darwinModules.home-manager
      self.darwinModules.getchoo
      {
        getchoo.base.enable = true;
        system.stateVersion = 4;
      }
    ];

    specialArgs = inputs;
  };

  server = {
    builder = inputs.nixpkgs-stable.lib.nixosSystem;

    modules = with inputs; [
      ragenix.nixosModules.default
      ../modules/nixos/base
      ../modules/nixos/server
      ../modules/nixos/features/tailscale.nix

      {
        getchoo = {
          features.tailscale = {
            enable = true;
            ssh.enable = true;
          };

          server = {
            enable = true;
            services.promtail.enable = true;
          };
        };

        nix.registry.nixpkgs.flake = nixpkgs-stable;
        system.stateVersion = "23.05";
      }
    ];

    specialArgs = inputs;
  };
}
