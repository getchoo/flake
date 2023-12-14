{
  config,
  lib,
  ...
}: let
  mkProxy = endpoint: port: {
    "${endpoint}" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };

  toVHosts = lib.mapAttrs' (
    name: value: lib.nameValuePair "${name}.${config.networking.domain}" value
  );
in {
  server.services.cloudflared.enable = true;

  services.nginx = {
    enable = true;

    clientMaxBodySize = "1250m";

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = toVHosts {
      cache = {
        locations = mkProxy "/" "5000";
      };

      miniflux = {
        locations = mkProxy "/" "7000";
      };

      msix = {
        root = "/var/www/msix";
      };
    };
  };
}
