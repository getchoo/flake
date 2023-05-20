{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
in {
  networking.firewall.allowedTCPPorts = [80 443];

  security.acme = {
    acceptTerms = true;
    defaults.email = "getchoo@tuta.io";
  };

  services.nginx = {
    enable = true;

    additionalModules = [pkgs.nginxModules.fancyindex];

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    statusPage = true;

    virtualHosts = let
      mkProxy = endpoint: port: {
        "${endpoint}" = {
          proxyPass = "http://127.0.0.1:${port}";
          proxyWebsockets = true;
        };
      };
    in {
      "api.${domain}" = {
        enableACME = true;
        serverAliases = ["www.api.${domain}"];

        locations = mkProxy "/" "8080";
      };

      "git.${domain}" = {
        enableACME = true;
        serverAliases = ["www.git.${domain}"];

        locations = mkProxy "/" "3000";
      };

      "grafana.${domain}" = {
        enableACME = true;
        serverAliases = ["www.grafana.${domain}"];
        locations = mkProxy "/" "4000";
      };
    };
  };
}
