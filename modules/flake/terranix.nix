{
  lib,
  flake-parts-lib,
  inputs,
  ...
}: let
  namespace = "terranix";

  inherit
    (lib)
    literalExpression
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
      ...
    }: let
      cfg = config.${namespace};
    in {
      options.${namespace} = {
        modules = mkOption {
          type = types.listOf types.unspecified;
          default = [];
          example = literalExpression "[ ./terranix ]";
          description = ''
            Modules to use in this terranixConfiguration
          '';
        };

        package = mkPackageOption pkgs "opentofu" {
          default = ["opentofu"];
          example = literalExpression "pkgs.opentofu.withPlugins (plugins: [ plugins.tailscale ] )";
        };
      };

      config = {
        packages.terranix = inputs.terranix.lib.terranixConfiguration {
          inherit system;
          inherit (cfg) modules;
        };
      };
    });
  };
}
