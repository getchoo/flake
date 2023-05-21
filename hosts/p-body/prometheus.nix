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
    port = 5000;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 5001;
      };
    };
    scrapeConfigs = [
      (scrapeExporter "p-body" "127.0.0.1" "${toString config.services.prometheus.exporters.node.port}")
      (scrapeExporter "atlas" "atlas" "5001")
    ];
  };

  getchoo.server.services.promtail.clients = [
    {
      url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
    }
  ];
}
