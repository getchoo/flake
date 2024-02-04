{
  config,
  lib,
  withSystem,
  inputs,
  self,
  ...
}: let
  namespace = "configurations";
  cfg = config.${namespace};

  inherit
    (lib)
    genAttrs
    literalExpression
    mapAttrs
    mdDoc
    mkOption
    recursiveUpdate
    types
    ;

  builderType = types.functionTo pkgsType;
  modulesType = types.listOf types.unspecified;
  pkgsType = types.lazyAttrsOf types.raw;

  kernelFor = type:
    {
      nixos = "linux";
      darwin = "darwin";
    }
    .${type};

  builderStringFor = type:
    {
      nixos = "inputs.nixpkgs.lib.nixosSystem";
      darwin = "inputs.nix-darwin.lib.darwinSystem";
    }
    .${type};

  inputsFor = system: withSystem system ({inputs', ...}: inputs');

  mkSystem = type: name: let
    args = cfg.${type}.systems.${name};
  in
    args.builder (lib.recursiveUpdate (removeAttrs args ["builder"]) {
      modules =
        [
          ../../systems/${name}
          {networking.hostName = name;}
        ]
        ++ lib.attrValues self."${type}Modules"
        ++ cfg.${type}.modules
        ++ args.modules;

      specialArgs = {
        inherit inputs;
        inputs' = inputsFor args.system;
        secretsDir = ../../secrets/${name};
      };
    });

  mkUser = name: let
    args = cfg.home.users.${name};
  in
    args.builder (recursiveUpdate (removeAttrs args ["builder"]) {
      inherit (args) pkgs;

      modules =
        [
          ../../users/${name}/home.nix

          {
            _module.args.osConfig = {};
            programs.home-manager.enable = true;
          }
        ]
        ++ cfg.home.modules
        ++ args.modules;

      extraSpecialArgs = {
        inherit inputs;
        inputs' = inputsFor args.pkgs.stdenv.hostPlatform.system;
      };
    });

  mapSystems = type: mapAttrs (name: _: mkSystem type name) cfg.${type}.systems;
  mapUsers = mapAttrs (name: _: mkUser name) cfg.home.users;

  systemsSubmodule = type: {
    options = {
      builder = mkOption {
        type = builderType;
        default = cfg.${type}.builder;
        example = literalExpression (builderStringFor type);
        description = mdDoc ''
          Function to build this ${type}Configuration with
        '';
      };

      modules = mkOption {
        type = modulesType;
        default = [];
        example = literalExpression "[ self.${type}Modules.default ]";
        description = mdDoc ''
          Extra modules to add to this ${type}Configuration
        '';
      };

      system = mkOption {
        type = types.str;
        default = "x86_64-${kernelFor type}";
        example = literalExpression "aarch64-${kernelFor type}";
        description = mdDoc ''
          System to build this ${type}Configuration for
        '';
      };
    };
  };

  usersSubmodule = {
    options = {
      builder = mkOption {
        type = builderType;
        default = cfg.home.builder;
        example = literalExpression "inputs.home-manager.lib.homeManagerConfiguration";
        description = mdDoc ''
          Function to build this homeConfiguration with
        '';
      };

      modules = mkOption {
        type = modulesType;
        default = [];
        example = literalExpression "[ self.hmModules.default ]";
        description = mdDoc ''
          Extra modules to add to this homeConfiguration
        '';
      };

      pkgs = mkOption {
        type = pkgsType;
        default = cfg.home.pkgs;
        example = literalExpression "inputs.nixpkgs.legacyPackages.aarch64-linux";
        description = mdDoc ''
          Instance of nixpkgs to use in this homeConfiguration
        '';
      };
    };
  };

  mkSystemOptions = type: {
    builder = mkOption {
      type = builderType;
      example = literalExpression (builderStringFor type);
      description = mdDoc ''
        Default function to build ${type}Configurations with
      '';
    };

    modules = mkOption {
      type = modulesType;
      default = [];
      example = literalExpression "[ self.${type}Modules.default ]";
      description = mdDoc ''
        List of modules to add to all ${type}Configurations
      '';
    };

    systems = mkOption {
      type = types.attrsOf (types.submodule (systemsSubmodule type));
      default = {};
      example = literalExpression ''
        {
          foo = {
            system = "aarch64-${kernelFor type}";
          };
        }
      '';
      description = mdDoc ''
        Attribute set of ${type}Configuration definitions
      '';
    };
  };
in {
  options.${namespace} =
    genAttrs ["nixos" "darwin"] mkSystemOptions
    // {
      home = {
        builder = mkOption {
          type = builderType;
          example = literalExpression "inputs.home-manager.lib.homeManagerConfiguration";
          description = mdDoc ''
            Default function to build homeConfigurations with
          '';
        };

        modules = mkOption {
          type = modulesType;
          default = [];
          example = literalExpression "[ self.homeModules.default ]";
          description = mdDoc ''
            List of modules to add to all homeConfigurations
          '';
        };

        pkgs = mkOption {
          type = pkgsType;
          example = literalExpression "inputs.nixpkgs.legacyPackages.aarch64-linux";
          description = mdDoc ''
            Default instance of nixpkgs to use in homeConfigurations
          '';
        };

        users = mkOption {
          type = types.attrsOf (types.submodule usersSubmodule);
          default = {};
          example = literalExpression ''
            {
              john = {
                pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
              };
            }
          '';
          description = mdDoc ''
            Attribute set of homeConfiguration definitions
          '';
        };
      };
    };

  config.flake = {
    nixosConfigurations = mapSystems "nixos";
    darwinConfigurations = mapSystems "darwin";
    homeConfigurations = mapUsers;
  };
}
