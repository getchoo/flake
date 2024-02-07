{
  config,
  lib,
  unstable,
  secretsDir,
  ...
}: let
  cfg = config.traits.hercules-ci;
in {
  options.traits.hercules-ci = {
    enable = lib.mkEnableOption "hercules-ci";
    manageSecrets = lib.mkEnableOption "automatic secrets management";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services = {
          hercules-ci-agent = {
            enable = true;
            package = unstable.hercules-ci-agent;
            settings = {
              binaryCachesPath = config.age.secrets.binaryCache.path;
              clusterJoinTokenPath = config.age.secrets.clusterToken.path;
              secretsJsonPath = config.age.secrets.secretsJson.path;
            };
          };
        };
      }

      (let
        hercArgs = {
          mode = "400";
          owner = "hercules-ci-agent";
          group = "hercules-ci-agent";
        };

        mkSecrets = lib.mapAttrs (_: file: lib.recursiveUpdate hercArgs {inherit file;});
      in
        lib.mkIf cfg.manageSecrets {
          age.secrets = mkSecrets {
            binaryCache = secretsDir + "/binaryCache.age";
            clusterToken = secretsDir + "/clusterToken.age";
            secretsJson = secretsDir + "/secretsJson.age";
          };
        })
    ]
  );
}
