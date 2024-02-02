{
  lib,
  flake-parts-lib,
  ...
}: let
  namespace = "terranix";

  inherit
    (lib)
    literalExpression
    mdDoc
    mkOption
    mkPackageOption
    types
    ;

  inherit
    (flake-parts-lib)
    mkPerSystemOption
    ;
in {
  options = {
    perSystem = mkPerSystemOption ({
      config,
      pkgs,
      system,
      self',
      ...
    }: let
      cfg = config.${namespace};
    in {
      options.${namespace} = {
        builder = mkOption {
          type = types.functionTo (types.lazyAttrsOf types.raw);
          example = literalExpression "inputs.terranix.lib.terranixConfiguration";
          description = mdDoc ''
            Function used to build this terranixConfiguration
          '';
        };

        modules = mkOption {
          type = types.listOf types.unspecified;
          default = [];
          example = literalExpression "[ ./terranix ]";
          description = mdDoc ''
            Modules to use in this terranixConfiguration
          '';
        };

        configuration = mkOption {
          type = types.pathInStore;
          readOnly = true;
          description = mdDoc ''
            Final configuration created by terranix
          '';
        };

        package = mkPackageOption pkgs "opentofu" {
          default = ["opentofu"];
          example = literalExpression "pkgs.opentofu.withPlugins (plugins: [ plugins.tailscale ] )";
        };
      };

      config = {
        terranix.configuration = cfg.builder {
          inherit system;
          inherit (cfg) modules;
        };

        apps.gen-terranix = {
          program = pkgs.writeShellApplication {
            name = "gen-tf";

            text = ''
              config_file="config.tf.json"
              [ -e "$config_file" ] && rm -f "$config_file"
              cp ${cfg.configuration} "$config_file"
            '';
          };
        };

        devShells.terranix = pkgs.mkShellNoCC {
          shellHook = ''
            ${self'.apps.gen-terranix.program}
          '';

          packages = [pkgs.just cfg.package];
        };
      };
    });
  };
}
