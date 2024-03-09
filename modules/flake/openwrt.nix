{
  config,
  lib,
  withSystem,
  inputs,
  ...
}: let
  namespace = "openWrtImages";
  cfg = config.${namespace};

  inherit
    (lib)
    literalExpression
    mdDoc
    mkOption
    types
    ;

  openWrtSubmodule = {
    freeformType = types.attrsOf types.anything;
    options = {
      profile = mkOption {
        type = types.str;
        example = literalExpression "netgear_wac104";
        description = mdDoc ''
          Device profile to build images for.
        '';
      };

      release = mkOption {
        type = types.str;
        default = "23.05.0";
        example = literalExpression "23.05.2";
        description = mdDoc ''
          OpenWRT release to base image off of
        '';
      };
    };
  };
in {
  options.${namespace} = mkOption {
    type = types.attrsOf (types.submodule openWrtSubmodule);
    default = {};
    description = mdDoc ''
      Generated OpenWRT images
    '';
  };

  config.flake.legacyPackages.x86_64-linux = {
    ${namespace} = withSystem "x86_64-linux" (
      {pkgs, ...}: let
        profileFromRelease = release:
          (inputs.openwrt-imagebuilder.lib.profiles {
            inherit pkgs release;
          })
          .identifyProfile;

        mkImage = {profile, ...} @ args:
          inputs.openwrt-imagebuilder.lib.build (
            profileFromRelease args.release profile
            // builtins.removeAttrs args ["profile" "release"]
          );
      in
        lib.mapAttrs (lib.const mkImage) cfg
    );
  };
}
