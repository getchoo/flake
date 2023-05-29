{config, ...}: let
  scrapeExporter = name: host: port: {
    job_name = "${name}";
    static_configs = [
      {
        targets = [
          "${host}:${port}"
        ];
      }
    ];
  };
in {
  services.prometheus = {
    enable = true;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
      };
    };
    scrapeConfigs = [
      (scrapeExporter "p-body" "localhost" "${toString config.services.prometheus.exporters.node.port}")
      (scrapeExporter "atlas" "atlas" "${toString config.services.prometheus.exporters.node.port}")
    ];
  };

  getchoo.server.services.promtail.clients = [
    {
      url = "http://localhost:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
    }
  ];
}
