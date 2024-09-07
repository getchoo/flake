{
  config,
  lib,
  withSystem,
  inputs,
  self,
  ...
}:
let
  nixosSystem =
    {
      nixpkgs,
      modules,
      specialArgs,
      ...
    }@args:
    nixpkgs.lib.nixosSystem (
      lib.removeAttrs args [ "nixpkgs" ]
      // {
        modules = modules ++ builtins.attrValues (self.nixosModules or [ ]);
        specialArgs = specialArgs // {
          inherit inputs;
        };
      }
    );

  darwinSystem =
    {
      nix-darwin,
      modules,
      specialArgs,
      ...
    }@args:
    nix-darwin.lib.darwinSystem (
      lib.removeAttrs args [ "nix-darwin" ]
      // {
        modules = modules ++ builtins.attrValues (self.darwinModules or { });
        specialArgs = specialArgs // {
          inherit inputs;
        };
      }
    );

  homeManagerConfiguration =
    {
      modules,
      extraSpecialArgs,
      ...
    }@args:
    inputs.home-manager.lib.homeManagerConfiguration (
      args
      // {
        modules = modules ++ builtins.attrValues (self.homeModules or self.homeManagerModules or { });
        extraSpecialArgs = extraSpecialArgs // {
          inherit inputs;
        };
      }
    );

  modulesOption = lib.mkOption {
    type = lib.types.listOf lib.types.unspecified;
    default = [ ];
    description = ''
      List of modules to use in the configuration
    '';
  };

  specialArgsOption = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
    description = ''
      Extra arguments to pass to the configuration
    '';
  };

  freeformType = lib.types.attrsOf lib.types.raw;

  nixosConfigurationSubmodule = {
    inherit freeformType;

    options = {
      nixpkgs = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.raw;
        default = inputs.nixpkgs or (throw "Could not find flake input `nixpkgs`");
        description = ''
          Instance of nixpkgs to use `lib.nixosSystem` from
        '';
        example = lib.literalExpression ''
          inputs.nixpkgs-stable
        '';
      };

      modules = modulesOption;
      specialArgs = specialArgsOption;
    };
  };

  homeConfigurationSubmodule = {
    inherit freeformType;

    options = {
      pkgs = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.raw;
        default = withSystem "x86_64-linux" ({ pkgs, ... }: pkgs);
        description = ''
          Instance of nixpkgs to use with the configuration
        '';
        example = lib.literalExpression ''
          inputs.nixpkgs.legacyPackages.aarch64-darwin
        '';
      };

      modules = modulesOption;
      extraSpecialArgs = specialArgsOption;
    };
  };

  darwinConfigurationSubmodule = {
    inherit freeformType;

    options = {
      nix-darwin = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.raw;
        default =
          inputs.nix-darwin or inputs.darwin
            or (throw "Could not find flake input `nixpkgs` or `nix-darwin`");
        description = ''
          Instance of nix-darwin to use `lib.nix-darwin` from
        '';
      };

      modules = modulesOption;
      specialArgs = specialArgsOption;
    };
  };
in

{
  options = {
    nixosConfigurations = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.submodule nixosConfigurationSubmodule);
      default = { };
      apply = lib.mapAttrs (lib.const nixosSystem);
      description = ''
        Map of configuration names and arguments to `nixosSystem`
      '';
      example = lib.literalExpression ''
        {
          my-machine = { modules = [ ./configuration.nix ]; };
        }
      '';
    };

    homeConfigurations = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.submodule homeConfigurationSubmodule);
      default = { };
      apply = lib.mapAttrs (lib.const homeManagerConfiguration);
      description = ''
        Map of configuration names and arguments to `homeManagerConfiguration`
      '';
      example = lib.literalExpression ''
        {
          me = { pkgs = nixpkgs.legacyPackages.x86_64-linux; };
        }
      '';
    };

    darwinConfigurations = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.submodule darwinConfigurationSubmodule);
      default = { };
      apply = lib.mapAttrs (lib.const darwinSystem);
      description = ''
        Map of configuration names and arguments to `darwinSystem`
      '';
      example = lib.literalExpression ''
        {
          my-mac = { modules = [ ./darwin-configuration.nix ]; };
        }
      '';
    };
  };

  config.flake = {
    inherit (config) nixosConfigurations homeConfigurations darwinConfigurations;
    /*
      nixosConfigurations = lib.mapAttrs (lib.const nixosSystem) config.nixosConfigurations;
      homeConfigurations = lib.mapAttrs (lib.const homeManagerConfiguration) config.homeConfigurations;
      darwinConfigurations = lib.mapAttrs (lib.const darwinSystem) config.darwinConfigurations;
    */
  };
}
