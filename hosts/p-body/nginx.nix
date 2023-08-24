{
  config,
  self,
  ...
}: let
  inherit (config.networking) domain;
  inherit (self.lib.utils.nginx) mkProxy mkVHosts;
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
      "api.${domain}" = {
        locations = mkProxy "/" "8080";
      };

      "grafana.${domain}" = {
        locations = mkProxy "/" "4000";
      };
    };
  };
}
