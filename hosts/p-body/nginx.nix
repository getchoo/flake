{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
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
        "api.${domain}" = {
          locations = mkProxy "/" "8080";
        };

        "grafana.${domain}" = {
          locations = mkProxy "/" "4000";
        };
      };
  };
}
