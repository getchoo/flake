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
      (scrapeExporter "atlas" "127.0.0.1" "${toString config.services.prometheus.exporters.node.port}")
    ];
  };

  getchoo.server.services.promtail.clients = [
    {
      url = "p-body:3030/loki/api/v1/push";
    }
  ];
}
