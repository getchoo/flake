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
      inherit (config.networking) domain;

      mkProxy = endpoint: port: {
        "${endpoint}" = {
          proxyPass = "http://localhost:${port}";
          proxyWebsockets = true;
        };
      };

      mkVHosts = builtins.mapAttrs (_: v:
        v
        // {
          enableACME = true;
          # workaround for https://github.com/NixOS/nixpkgs/issues/210807
          acmeRoot = null;
          forceSSL = true;
        });
    in
      mkVHosts {
        "miniflux.${domain}" = {
          locations = mkProxy "/" "7000";
        };

        "msix.${domain}" = {
          root = "/var/www/msix";
        };
      };
  };
}
