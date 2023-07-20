{config, ...}: let
  inherit (config.networking) domain;
in {
  networking.firewall.allowedTCPPorts = [443];

  security.acme = {
    acceptTerms = true;
    defaults.email = "getchoo@tuta.io";
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    statusPage = true;

    virtualHosts = let
      mkProxy = endpoint: port: {
        "${endpoint}" = {
          proxyPass = "http://localhost:${port}";
          proxyWebsockets = true;
        };
      };
    in {
      "api.${domain}" = {
        enableACME = true;
        addSSL = true;

        locations = mkProxy "/" "8080";
      };

      "grafana.${domain}" = {
        enableACME = true;
        addSSL = true;

        locations = mkProxy "/" "4000";
      };
    };
  };
}
