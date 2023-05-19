{config, ...}: let
  inherit (config.networking) domain;
in {
  services.grafana = {
    enable = true;
    settings = {
      "auth.anonymous" = {
        enabled = true;
        hide_version = true;
        org_name = "getchoosystems";
        org_role = "Viewer";
      };

      server = {
        http_addr = "127.0.0.1";
        http_port = 4000;
        domain = "grafana.${domain}";
      };

      feature_toggles = {
        publicDashboards = true;
      };
    };
  };
}
