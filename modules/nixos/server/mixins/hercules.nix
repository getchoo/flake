{
  config,
  lib,
  unstable,
  secretsDir,
  ...
}:
let
  cfg = config.server.mixins.hercules-ci;
in
{
  options.server.mixins.hercules-ci = {
    enable = lib.mkEnableOption "Hercules CI mixin";
    manageSecrets = lib.mkEnableOption "automatic management of secrets" // {
      default = config.traits.secrets.enable;
      defaultText = lib.literalExpression "config.traits.secrets.enable";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.hercules-ci-agent = {
          enable = true;
          # we want newer features
          package = unstable.hercules-ci-agent;
        };
      }

      (
        let
          secretNames = [
            "binaryCaches"
            "clusterJoinToken"
            "secretsJson"
          ];
        in
        lib.mkIf cfg.manageSecrets {
          age.secrets = lib.genAttrs secretNames (file: {
            file = "${secretsDir}/${file}.age";
            mode = "400";
            owner = "hercules-ci-agent";
            group = "hercules-ci-agent";
          });

          services.hercules-ci-agent = {
            settings = lib.mapAttrs' (name: lib.nameValuePair (name + "Path")) (
              lib.genAttrs secretNames (name: config.age.secrets.${name}.path)
            );
          };
        }
      )
    ]
  );
}
