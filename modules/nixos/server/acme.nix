{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.getchoo.server.acme;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.server.acme = {
    enable = mkEnableOption "acme";
  };

  config = mkIf cfg.enable {
    age.secrets.cloudflareApiKey.file = "${self}/secrets/shared/cloudflareApiKey.age";

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
