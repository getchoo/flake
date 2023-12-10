{
  config,
  lib,
  unstable,
  secretsDir,
  ...
}: let
  cfg = config.server.services.hercules-ci;
  inherit (lib) mkEnableOption mkIf;

  hercArgs = {
    mode = "400";
    owner = "hercules-ci-agent";
    group = "hercules-ci-agent";
  };
in {
  options.server.services.hercules-ci = {
    enable = mkEnableOption "enable hercules-ci";
    secrets.enable = mkEnableOption "manage secrets for hercules-ci";
  };

  config = mkIf cfg.enable {
    age.secrets = mkIf cfg.secrets.enable {
      binaryCache =
        {
          file = secretsDir + "/binaryCache.age";
        }
        // hercArgs;

      clusterToken =
        {
          file = secretsDir + "/clusterToken.age";
        }
        // hercArgs;

      secretsJson =
        {
          file = secretsDir + "/secretsJson.age";
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
