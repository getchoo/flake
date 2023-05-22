{config, ...}: {
  networking.firewall.allowedTCPPorts = [config.services.prometheus.exporters.node.port];

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = ["systemd"];
  };

  getchoo.server.services.promtail.clients = [
    {
      url = "http://p-body:3030/loki/api/v1/push";
    }
  ];
}
