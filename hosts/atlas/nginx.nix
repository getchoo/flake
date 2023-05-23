{config, ...}: {
  networking.firewall.allowedTCPPorts = [80 443];

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

    virtualHosts = let
      mkProxy = endpoint: port: {
        "${endpoint}" = {
          proxyPass = "http://127.0.0.1:${port}";
          proxyWebsockets = true;
        };
      };
      inherit (config.networking) domain;
    in {
      "miniflux.${domain}" = {
        enableACME = true;
        addSSL = true;

        locations = mkProxy "/" "7000";
      };
    };
  };
}
