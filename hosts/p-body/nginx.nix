{config, ...}: let
  inherit (config.networking) domain;
in {
  getchoo.server.acme.enable = true;
  networking.firewall.allowedTCPPorts = [443];

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
        "api.${domain}" = {
          locations = mkProxy "/" "8080";
        };

        "grafana.${domain}" = {
          locations = mkProxy "/" "4000";
        };
      };
  };
}
