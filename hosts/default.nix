inputs:
with inputs; let
  common = rec {
    system = "x86_64-linux";
    builder = nixpkgsUnstable.lib.nixosSystem;

    modules = [
      ragenix.nixosModules.default
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur

      self.nixosModules.getchoo
      users.seth.default

      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = "${self}/users/_secrets/rootPassword.age";
            sethPassword.file = "${self}/users/_secrets/sethPassword.age";
            pbodyPassword.file = "${self}/users/_secrets/pbodyPassword.age";
          };
        };

        nixpkgs = {
          overlays = [nur.overlay getchoo.overlays.default];
          config.allowUnfree = true;
        };

        nix.registry.getchoo.flake = getchoo;
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
        (import "${self}/modules/nixos/virtualisation.nix")
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
      (import "${self}/modules/base")
      (import "${self}/modules/nixos")
      (import "${self}/modules/server")

      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = "${self}/users/_secrets/rootPassword.age";
            atlasPassword.file = "${self}/users/_secrets/atlasPassword.age";
          };
        };

        _module.args.nixinate = {
          host = "164.152.18.102";
          sshUser = "atlas";
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
      (import "${self}/modules/base")
      (import "${self}/modules/nixos")
      (import "${self}/modules/server")

      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = "${self}/users/_secrets/rootPassword.age";
            pbodyPassword.file = "${self}/users/_secrets/pbodyPassword.age";
          };
        };

        _module.args.nixinate = {
          host = "167.99.145.73";
          sshUser = "p-body";
          buildOn = "remote";
          substituteOnTarget = true;
          hermetic = false;
        };
      }
    ];
  };
}
