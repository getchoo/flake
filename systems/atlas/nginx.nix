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
  services.nginx = {
    enable = true;

    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;

    virtualHosts = toVHosts {
      miniflux = {
        locations = mkProxy "/" "7000";
      };

      msix = {
        root = "/var/www/msix";
      };
    };
  };
}
