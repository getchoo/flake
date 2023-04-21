inputs:
with inputs; let
  common = rec {
    system = "x86_64-linux";
    builder = nixpkgsUnstable.lib.nixosSystem;

    modules = [
      agenix.nixosModules.default
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur

      self.nixosModules.getchoo
      "${self}/users/seth"

      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = "${self}/users/_secrets/rootPassword.age";
            sethPassword.file = "${self}/users/_secrets/sethPassword.age";
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
}
