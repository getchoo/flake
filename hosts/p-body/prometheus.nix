{config, ...}: let
  scrapeExporter = name: exporter: {
    job_name = "${name}";
    static_configs = [
      {
        targets = [
          "127.0.0.1:${toString config.services.prometheus.exporters.${exporter}.port}"
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
      (scrapeExporter "p-body" "node")
    ];
  };
}
