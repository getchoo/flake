{
  lib,
  inputs,
  ...
}: let
  inherit (lib.my) configs utils;
in {
  applySpecialArgsFor = system:
    lib.recursiveUpdate {
      inherit inputs;
      inputs' = utils.inputsFor system;
    };

  toSystem = type: name: args:
    args.builder (
      lib.recursiveUpdate (builtins.removeAttrs args ["builder"]) {
        modules =
          [
            ../systems/${name}
            {networking.hostName = name;}
          ]
          ++ lib.attrValues (inputs.self."${type}Modules" or {})
          ++ (args.modules or []);

        specialArgs = configs.applySpecialArgsFor args.system (args.specialArgs or {});
      }
    );

  toUser = name: args:
    inputs.home-manager.lib.homeManagerConfiguration (
      lib.recursiveUpdate args {
        modules =
          [
            ../users/${name}/home.nix

            {
              _module.args.osConfig = {};
              programs.home-manager.enable = true;
            }
          ]
          ++ lib.attrValues (inputs.self.homeModules or {})
          ++ (args.modules or []);

        extraSpecialArgs = let
          inherit (args.pkgs.stdenv.hostPlatform) system;
        in
          configs.applySpecialArgsFor system (args.extraSpecialArgs or {});
      }
    );

  mapSystems = type: lib.mapAttrs (configs.toSystem type);
  mapUsers = lib.mapAttrs configs.toUser;
  mapNixOS = configs.mapSystems "nixos";
  mapDarwin = configs.mapSystems "darwin";
}
