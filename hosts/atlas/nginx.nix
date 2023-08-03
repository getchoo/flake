{config, ...}: {
  getchoo.server.acme.enable = true;
  networking.firewall.allowedTCPPorts = [443];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "getchoo@tuta.io";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflareApiKey.path;
    };
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
          proxyPass = "http://localhost:${port}";
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
