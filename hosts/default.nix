inputs:
with inputs; let
  common = {
    system = "x86_64-linux";
    builder = nixpkgsUnstable.lib.nixosSystem;

    modules = [
      ragenix.nixosModules.default
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur

      self.nixosModules.getchoo
      "${self}/users/seth"

      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = "${self}/secrets/shared/rootPassword.age";
            sethPassword.file = "${self}/secrets/shared/sethPassword.age";
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

        nixos.enable = true;
        system.stateVersion = "23.05";
      }
    ];

    specialArgs = {};
  };
in {
  glados = {
    inherit (common) builder specialArgs system;
    modules =
      common.modules
      ++ [
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        nixos-hardware.nixosModules.common-pc-ssd
        lanzaboote.nixosModules.lanzaboote
      ];
  };
  glados-wsl = {
    inherit (common) builder specialArgs system;
    modules =
      common.modules
      ++ [
        nixos-wsl.nixosModules.wsl
      ];
  };
  atlas = {
    builder = nixpkgs.lib.nixosSystem;
    inherit (common) specialArgs;
    system = "aarch64-linux";

    modules = [
      ragenix.nixosModules.default
      "${self}/modules/base"
      "${self}/modules/nixos"
      "${self}/modules/server"

      {
        age = let
          hercArgs = {
            mode = "400";
            owner = "hercules-ci-agent";
            group = "hercules-ci-agent";
          };
        in {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = "${self}/secrets/hosts/atlas/rootPassword.age";
            atlasPassword.file = "${self}/secrets/hosts/atlas/atlasPassword.age";

            binaryCache =
              {
                file = "${self}/secrets/hosts/atlas/binaryCache.age";
              }
              // hercArgs;

            clusterToken =
              {
                file = "${self}/secrets/hosts/atlas/clusterToken.age";
              }
              // hercArgs;

            secretsJson =
              {
                file = "${self}/secrets/hosts/atlas/secretsJson.age";
              }
              // hercArgs;
          };
        };

        nix.registry.nixpkgs.flake = nixpkgs;

        _module.args.nixinate = {
          host = "164.152.17.183";
          sshUser = "root";
          buildOn = "remote";
          substituteOnTarget = true;
          hermetic = false;
        };
      }
    ];
  };
  p-body = {
    builder = nixpkgs.lib.nixosSystem;
    inherit (common) specialArgs system;

    modules = [
      ragenix.nixosModules.default
      guzzle_api.nixosModules.guzzle_api
      "${self}/modules/base"
      "${self}/modules/nixos"
      "${self}/modules/server"

      {
        age = let
          hercArgs = {
            mode = "400";
            owner = "hercules-ci-agent";
            group = "hercules-ci-agent";
          };
        in {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = "${self}/secrets/hosts/p-body/rootPassword.age";
            pbodyPassword.file = "${self}/secrets/hosts/p-body/pbodyPassword.age";

            binaryCache =
              {
                file = "${self}/secrets/hosts/p-body/binaryCache.age";
              }
              // hercArgs;

            clusterToken =
              {
                file = "${self}/secrets/hosts/p-body/clusterToken.age";
              }
              // hercArgs;

            secretsJson =
              {
                file = "${self}/secrets/hosts/p-body/secretsJson.age";
              }
              // hercArgs;
          };
        };

        nix.registry.nixpkgs.flake = nixpkgs;

        _module.args.nixinate = {
          host = "167.99.145.73";
          sshUser = "root";
          buildOn = "remote";
          substituteOnTarget = true;
          hermetic = false;
        };
      }
    ];
  };
}
