{
  config,
  lib,
  flake-parts-lib,
  inputs,
  moduleLocation,
  withSystem,
  ...
}: let
  inherit (flake-parts-lib) mkSubmoduleOptions;

  inherit
    (builtins)
    removeAttrs
    ;

  inherit
    (lib)
    attrValues
    literalExpression
    mapAttrs
    mkAliasOptionModule
    mkOption
    recursiveUpdate
    types
    ;

  inherit
    (inputs)
    nixpkgs
    darwin
    home-manager
    ;

  pkgsType = types.lazyAttrsOf types.raw;
  builderType = types.functionTo pkgsType;

  defaultBuilderFor = {
    nixos = nixpkgs.lib.nixosSystem;
    darwin = (inputs.nix-darwin or darwin).lib.darwinSystem;
  };

  builderStringFor = {
    nixos = "inputs.nixpkgs.lib.nixosSystem";
    darwin = "inputs.nix-darwin.lib.darwinSystem";
  };

  kernelFor = {
    nixos = "linux";
    darwin = "darwin";
  };

  applySpecialArgsFor = system:
    recursiveUpdate {
      inherit inputs;
      inputs' = withSystem system ({inputs', ...}: inputs');
    };

  toSystem = type: name: args:
    args.builder (
      recursiveUpdate (removeAttrs args ["builder"]) {
        modules =
          [
            ../../systems/${name}
            {networking.hostName = name;}
          ]
          ++ attrValues (inputs.self."${type}Modules" or {})
          ++ (args.modules or []);

        specialArgs = applySpecialArgsFor args.system (args.specialArgs or {});
      }
    );

  toUser = name: args:
    home-manager.lib.homeManagerConfiguration (
      recursiveUpdate args {
        modules =
          [
            ../../users/${name}/home.nix

            {
              _module.args.osConfig = {};
              programs.home-manager.enable = true;
            }
          ]
          ++ attrValues (inputs.self.homeModules or {})
          ++ (args.modules or []);

        extraSpecialArgs = let
          inherit (args.pkgs.stdenv.hostPlatform) system;
        in
          applySpecialArgsFor system (args.extraSpecialArgs or {});
      }
    );

  mapSystems = type: mapAttrs (toSystem type);
  mapUsers = mapAttrs toUser;
  mapNixOS = mapSystems "nixos";
  mapDarwin = mapSystems "darwin";

  systemsSubmodule = type: {
    freeformType = types.attrsOf types.any;

    options = {
      builder = mkOption {
        type = builderType;
        default = defaultBuilderFor.${type};
        example = literalExpression (builderStringFor type);
        description = ''
          Function to build this ${type}Configuration with
        '';
      };

      system = mkOption {
        type = types.str;
        default = "x86_64-${kernelFor type}";
        example = literalExpression "aarch64-${kernelFor type}";
        description = ''
          System to build this ${type}Configuration for
        '';
      };
    };
  };

  usersSubmodule = {
    freeformType = types.attrsOf types.any;

    options = {
      pkgs = mkOption {
        type = pkgsType;
        default = nixpkgs.legacyPackages.x86_64-linux;
        defaultText = "inputs.nixpkgs.legacyPackages.x86_64-linux";
        example = literalExpression "inputs.nixpkgs.legacyPackages.aarch64-linux";
        description = ''
          Instance of nixpkgs to use in this homeConfiguration
        '';
      };
    };
  };

  mkSystemOptions = type:
    mkOption {
      type = types.attrsOf (types.submodule (systemsSubmodule type));
      default = {};
      example = literalExpression ''
        {
          foo = {
            system = "aarch64-${kernelFor type}";
          };
        }
      '';
      description = ''
        Attribute set of `lib.${type}System` options. The names of
        each attribute will be used to import files in the `systems/`
        directory
      '';
    };
in {
  # i don't like prefixing so much with `flake`
  imports = [
    (mkAliasOptionModule ["deploy"] ["flake" "deploy"])
    (mkAliasOptionModule ["nixosModules"] ["flake" "nixosModules"])
    (mkAliasOptionModule ["darwinModules"] ["flake" "darwinModules"])
    (mkAliasOptionModule ["homeModules"] ["flake" "homeModules"])
    (mkAliasOptionModule ["flakeModules"] ["flake" "flakeModules"])
  ];

  options = {
    flake = mkSubmoduleOptions {
      darwinModules = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        default = {};
        apply = mapAttrs (name: value: {
          _file = "${toString moduleLocation}#darwinModules.${name}";
          imports = [value];
        });
      };
    };

    nixosConfigurations = mkSystemOptions "nixos";
    darwinConfigurations = mkSystemOptions "darwin";

    homeConfigurations = mkOption {
      type = types.attrsOf (types.submodule usersSubmodule);
      default = {};
      example = literalExpression ''
        {
          john = {
            pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
          };
        }
      '';
      description = ''
        Attribute set of `lib.homeManagerConfiguration` arguments. The
        name of each attribute will be used to import files in the `users/`
        directory.
      '';
    };
  };

  config.flake = {
    nixosConfigurations = mapNixOS config.nixosConfigurations;
    darwinConfigurations = mapDarwin config.darwinConfigurations;
    homeConfigurations = mapUsers config.homeConfigurations;
  };
}
