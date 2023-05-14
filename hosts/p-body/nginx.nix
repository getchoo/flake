{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
in {
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

    commonHttpConfig = ''

      # Add HSTS header with preloading to HTTPS requests.
      # Adding this header to HTTP requests is discouraged
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      # Enable CSP for your services.
      add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      # Minimize information leaked to other domains
      add_header 'Referrer-Policy' 'origin-when-cross-origin';

      # Disable embedding as a frame
      add_header X-Frame-Options DENY;

      # Prevent injection of code in other mime types (XSS Attacks)
      add_header X-Content-Type-Options nosniff;

      # Enable XSS protection of the browser.
      # May be unnecessary when CSP is configured properly (see above)
      add_header X-XSS-Protection "1; mode=block";
    '';

    virtualHosts = let
      mkProxy = endpoint: port: {
        "${endpoint}".proxyPass = "http://127.0.0.1:${port}";
      };
    in {
      "${domain}" = {
        default = true;
        enableACME = true;
        serverAliases = ["www.${domain}"];

        locations =
          {
            "/" = {
              root =
                pkgs.writeTextDir "index.html"
                ''
                  <!DOCTYPE html>
                  <html lang="en">
                    <body style="text-align: center;">
                      <iframe width="560" height="315" src="https://www.youtube.com/embed/voXpIgb9Nbk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
                    </body>
                  </html>
                '';

              index = "index.html";
            };
          }
          // mkProxy "/api" config.services.guzzle-api.port;
      };
    };
  };
}
