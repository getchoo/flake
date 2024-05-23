{
  config,
  lib,
  flake-parts-lib,
  inputs,
  self,
  moduleLocation,
  withSystem,
  ...
}: let
  inherit (flake-parts-lib) mkSubmoduleOptions;

  inherit
    (builtins)
    attrValues
    mapAttrs
    removeAttrs
    ;

  inherit
    (lib)
    const
    literalExpression
    mkOption
    recursiveUpdate
    types
    ;

  kernelFor = {
    nixos = "linux";
    darwin = "darwin";
  };

  applySpecialArgsFor = system:
    recursiveUpdate {
      inherit inputs;
      inputs' = withSystem system ({inputs', ...}: inputs');
    };

  toSystem = type: {
    modules ? [],
    system,
    specialArgs ? {},
    ...
  } @ args:
    args.builder (
      removeAttrs args ["builder"]
      // {
        modules = modules ++ attrValues (self."${type}Modules" or {});
        specialArgs = applySpecialArgsFor system specialArgs;
      }
    );

  toUser = {
    extraSpecialArgs ? {},
    modules ? [],
    pkgs,
  } @ args:
    inputs.home-manager.lib.homeManagerConfiguration (
      args
      // {
        modules = modules ++ attrValues (self.homeManagerModules or {});
        extraSpecialArgs = applySpecialArgsFor pkgs.stdenv.hostPlatform.system extraSpecialArgs;
      }
    );

  mapSystems = type: mapAttrs (const (toSystem type));
  mapUsers = mapAttrs (const toUser);
  mapNixOS = mapSystems "nixos";
  mapDarwin = mapSystems "darwin";

  systemsSubmodule = type: {
    freeformType = types.attrsOf types.anything;

    options = {
      builder = let
        error = throw "System configuration of type `${type}` is not supported!";
      in
        mkOption {
          type = types.functionTo (types.lazyAttrsOf types.raw);
          default =
            {
              nixos = inputs.nixpkgs.lib.nixosSystem;
              darwin = inputs.nix-darwin.lib.darwinSystem;
            }
            .${type}
            or error;
          example = literalExpression (
            {
              nixos = "inputs.nixpkgs.lib.nixosSystem";
              darwin = "inputs.nix-darwin.lib.darwinSystem";
            }
            .${type}
            or error
          );
          description = ''
            Function to build this ${type}Configuration with
          '';
        };

      system = mkOption {
        type = types.str;
        default = "x86_64-" + kernelFor.${type};
        example = literalExpression ("aarch64-" + kernelFor.${type});
        description = ''
          System to build this ${type}Configuration for
        '';
      };
    };
  };

  usersSubmodule = {
    freeformType = types.attrsOf types.anything;

    options = {
      pkgs = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = inputs.nixpkgs.legacyPackages.x86_64-linux;
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
          myComputer = {
            system = "aarch64${kernelFor type}";
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

    configurations = {
      nixos = mkSystemOptions "nixos";
      darwin = mkSystemOptions "darwin";

      home = mkOption {
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
  };

  config.flake = {
    nixosConfigurations = mapNixOS config.configurations.nixos;
    darwinConfigurations = mapDarwin config.configurations.darwin;
    homeConfigurations = mapUsers config.configurations.home;
  };
}
