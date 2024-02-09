{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.traits.acme;
in {
  options.traits.acme = {
    enable = lib.mkEnableOption "ACME support";

    manageSecrets =
      lib.mkEnableOption "automatic secrets management"
      // {
        default = config.traits.secrets.enable;
      };

    useDns = lib.mkEnableOption "the usage of dns to get certs" // {default = true;};
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
