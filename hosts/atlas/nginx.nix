{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
in {
  getchoo.server = {
    acme.enable = true;
    services.cloudflared.enable = true;
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

      mkVHosts = let
        commonSettings = {
          enableACME = true;
          # workaround for https://github.com/NixOS/nixpkgs/issues/210807
          acmeRoot = null;

          addSSL = true;
        };
      in
        builtins.mapAttrs (_: lib.recursiveUpdate commonSettings);
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
