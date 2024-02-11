{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.server.mixins.acme;
in {
  options.server.mixins.acme = {
    enable = lib.mkEnableOption "ACME mixin";

    manageSecrets =
      lib.mkEnableOption "automatic secrets management"
      // {
        default = config.traits.secrets.enable;
      };

    useDns = lib.mkEnableOption "the usage of Cloudflare to obtain certs" // {default = true;};
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        security.acme = {
          acceptTerms = true;
          defaults =
            {
              email = "getchoo@tuta.io";
            }
            // lib.optionalAttrs cfg.useDns {
              dnsProvider = "cloudflare";
            }
            // lib.optionalAttrs cfg.manageSecrets {
              credentialsFile = config.age.secrets.cloudflareApiKey.path;
            };
        };
      }

      (lib.mkIf cfg.manageSecrets {
        age.secrets = {
          cloudflareApiKey.file = secretsDir + "/cloudflareApiKey.age";
        };
      })
    ]
  );
}
