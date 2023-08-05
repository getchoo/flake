{config, ...}: let
  mkScrapes = let
    mkConfig = client: {
      job_name = "${client}";
      static_configs = [
        {
          targets = [
            "${client}:${toString config.services.prometheus.exporters.node.port}"
          ];
        }
      ];
    };
  in
    builtins.map mkConfig;
in {
  services = {
    victoriametrics.enable = true;

    vmagent = {
      enable = true;
      prometheusConfig = {
        scrape_configs = mkScrapes ["p-body" "atlas"];
      };
    };
  };
}
