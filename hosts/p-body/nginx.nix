{
  config,
  getchoo-website,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  website = getchoo-website.packages.${pkgs.system}.default;
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
        "${endpoint}".proxyPass = "http://127.0.0.1:${port}";
      };
    in {
      "${domain}" = {
        default = true;
        enableACME = true;
        serverAliases = ["www.${domain}"];

        locations."/" = {
          root = "${website}/libexec/getchoo-website/deps/getchoo-website/dist/";
          index = "index.html";
        };
      };

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

      "status.${domain}" = {
        enableACME = true;
        serverAliases = ["www.status.${domain}"];
        locations."/" = {
          root =
            pkgs.writeTextDir "notindex.html"
            ''
              lol
            '';
          index = "index.html";
          tryFiles = "$uri =404";
        };
      };
    };
  };
}
