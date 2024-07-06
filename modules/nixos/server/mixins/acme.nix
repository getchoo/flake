{
  config,
  lib,
  secretsDir,
  ...
}:
let
  cfg = config.server.mixins.acme;
in
{
  options.server.mixins.acme = {
    enable = lib.mkEnableOption "ACME mixin";

    manageSecrets = lib.mkEnableOption "automatic management of secrets" // {
      default = config.traits.secrets.enable;
      defaultText = lib.literalExpression "config.traits.secrets.enable";
    };

    useDns = lib.mkEnableOption "the use of Cloudflare to obtain certs" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        security.acme = {
          acceptTerms = true;
          defaults = {
            email = "getchoo@tuta.io";
          };
        };
      }

      (lib.mkIf cfg.useDns {
        security.acme.defaults = {
          dnsProvider = "cloudflare";
        };
      })

      (lib.mkIf cfg.manageSecrets {
        age.secrets = {
          cloudflareApiKey.file = secretsDir + "/cloudflareApiKey.age";
        };

        security.acme.defaults = {
          credentialsFile = config.age.secrets.cloudflareApiKey.path;
        };
      })
    ]
  );
}
