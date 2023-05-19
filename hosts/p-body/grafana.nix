{config, ...}: let
  inherit (config.networking) domain;
in {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 4000;
        domain = "grafana.${domain}";
      };
    };
  };
}
