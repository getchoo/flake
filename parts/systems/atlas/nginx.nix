{
  config,
  self,
  ...
}: let
  inherit (config.networking) domain;
  inherit (self.lib.utils.nginx) mkVHosts mkProxy;
in {
  server = {
    acme.enable = true;
    services.cloudflared.enable = true;
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = mkVHosts {
      "miniflux.${domain}" = {
        locations = mkProxy "/" "7000";
      };

      "msix.${domain}" = {
        root = "/var/www/msix";
      };
    };
  };
}
