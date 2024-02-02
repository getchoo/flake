{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.server.acme;
in {
  options.server.acme.enable = lib.mkEnableOption "ACME support";

  config = lib.mkIf cfg.enable {
    age.secrets = {
      cloudflareApiKey.file = secretsDir + "/cloudflareApiKey.age";
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "getchoo@tuta.io";
        dnsProvider = "cloudflare";
        credentialsFile = config.age.secrets.cloudflareApiKey.path;
      };
    };
  };
}
