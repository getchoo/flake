{
  inputs,
  self,
}: let
  inherit (inputs) getchoo home-manager nixpkgs nixpkgsUnstable nur ragenix;
in {
  personal = {
    system = "x86_64-linux";
    builder = nixpkgsUnstable.lib.nixosSystem;

    modules = [
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

        nixpkgs = {
          overlays = [nur.overlay getchoo.overlays.default];
          config.allowUnfree = true;
        };

        nix = {
          registry = {
            getchoo.flake = getchoo;
            nixpkgs.flake = nixpkgsUnstable;
          };

          settings = {
            trusted-substituters = [
              "https://getchoo.cachix.org"
              "https://nix-community.cachix.org"
              "https://hercules-ci.cachix.org"
              "https://wurzelpfropf.cachix.org"
            ];

            trusted-public-keys = [
              "getchoo.cachix.org-1:ftdbAUJVNaFonM0obRGgR5+nUmdLMM+AOvDOSx0z5tE="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
              "wurzelpfropf.cachix.org-1:ilZwK5a6wJqVr7Fyrzp4blIEkGK+LJT0QrpWr1qBNq0="
            ];
          };
        };

        getchoo.base.enable = true;
        system.stateVersion = "23.05";
      }
    ];

    specialArgs = inputs;
  };

  server = {
    builder = nixpkgs.lib.nixosSystem;

    modules = [
      ragenix.nixosModules.default
      ../modules/nixos/base
      ../modules/nixos/server
      ../modules/nixos/features/tailscale.nix

      {
        getchoo.features.tailscale.enable = true;
        getchoo.server.enable = true;
        nix.registry.nixpkgs.flake = nixpkgs;
      }
    ];

    specialArgs = inputs;
  };
}
