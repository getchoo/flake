{
  config,
  lib,
  self,
  unstable,
  ...
}: let
  cfg = config.server.services.hercules-ci;
  inherit (lib) mkEnableOption mkIf;
in {
  options.server.services.hercules-ci = {
    enable = mkEnableOption "enable hercules-ci";
    secrets.enable = mkEnableOption "manage secrets for hercules-ci";
  };

  config = mkIf cfg.enable {
    age.secrets = let
      baseDir = "${self}/secrets/hosts/${config.networking.hostName}";
      hercArgs = {
        mode = "400";
        owner = "hercules-ci-agent";
        group = "hercules-ci-agent";
      };
    in
      mkIf cfg.secrets.enable {
        binaryCache =
          {
            file = "${baseDir}/binaryCache.age";
          }
          // hercArgs;

        clusterToken =
          {
            file = "${baseDir}/clusterToken.age";
          }
          // hercArgs;

        secretsJson =
          {
            file = "${baseDir}/secretsJson.age";
          }
          // hercArgs;
      };

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
  };
}
