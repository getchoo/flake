{
  inputs,
  self,
  ...
}: let
  inherit (import ./common.nix {inherit inputs self;}) personal server;
in {
  flake = {
    nixosConfigurations = {
      glados = with personal;
        builder {
          inherit specialArgs system;
          modules = with inputs;
            modules
            ++ [
              ./glados
              nixos-hardware.nixosModules.common-cpu-amd-pstate
              nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
              nixos-hardware.nixosModules.common-pc-ssd
              lanzaboote.nixosModules.lanzaboote
            ];
        };

      glados-wsl = with personal;
        builder {
          inherit specialArgs system;
          modules = with inputs;
            modules
            ++ [
              ./glados-wsl
              nixos-wsl.nixosModules.wsl
            ];
        };

      atlas = with server;
        builder {
          inherit specialArgs;
          system = "aarch64-linux";
          modules = with inputs;
            modules
            ++ [
              ./atlas
              hercules-ci-agent.nixosModules.agent-service

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
        };

      p-body = with server;
        builder {
          inherit specialArgs;
          modules = with inputs;
            modules
            ++ [
              ./p-body
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
      turret = pkgs.callPackage ./_turret {inherit (inputs) openwrt-imagebuilder;};
    };
  };
}
