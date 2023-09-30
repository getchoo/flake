{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.server.acme;
  inherit (lib) mkEnableOption mkIf;
in {
  options.server.acme = {
    enable = mkEnableOption "acme";
  };

  config = mkIf cfg.enable {
    age.secrets.cloudflareApiKey.file = "${self}/src/_secrets/hosts/${config.networking.hostName}/cloudflareApiKey.age";

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
