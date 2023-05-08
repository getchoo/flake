{
  inputs,
  self,
  ...
}: let
  inherit (import ./profiles.nix {inherit inputs self;}) personal server;

  mkNixOS = {
    name,
    modules ? profile.modules,
    profile ? personal,
    system ? profile.system,
    specialArgs ? profile.specialArgs,
  }:
    profile.builder {
      inherit specialArgs system;
      modules = [./${name}] ++ modules ++ profile.modules;
    };
in {
  flake = {
    nixosConfigurations = {
      glados = mkNixOS {
        name = "glados";
        modules = with inputs; [
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          nixos-hardware.nixosModules.common-pc-ssd
          lanzaboote.nixosModules.lanzaboote
        ];
      };

      glados-wsl = mkNixOS {
        name = "glados-wsl";
        modules = [inputs.nixos-wsl.nixosModules.wsl];
      };

      atlas = mkNixOS {
        name = "atlas";
        modules = [
          inputs.hercules-ci-agent.nixosModules.agent-service

          {
            getchoo.server = {
              secrets.enable = true;
              services.hercules-ci = {
                enable = true;
                secrets.enable = true;
              };
            };
          }
        ];

        system = "aarch64-linux";
        profile = server;
      };

      p-body = mkNixOS {
        name = "p-body";
        modules = with inputs; [
          hercules-ci-agent.nixosModules.agent-service
          guzzle_api.nixosModules.guzzle_api

          {
            getchoo.server = {
              secrets.enable = true;
              services.hercules-ci = {
                enable = true;
                secrets.enable = true;
              };
            };
          }
        ];

        system = "x86_64-linux";
        profile = server;
      };
    };

    nixosModules.getchoo = import ../modules;
  };

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    apps = (inputs.nixinate.nixinate.${system} self).nixinate;

    packages = {
      turret = pkgs.callPackage ./turret {inherit (inputs) openwrt-imagebuilder;};
    };
  };
}
