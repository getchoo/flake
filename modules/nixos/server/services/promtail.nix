{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.server.services.promtail;
  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options.getchoo.server.services.promtail = {
    enable = mkEnableOption "enable promtail";

    clients = mkOption {
      type = types.listOf types.attrs;
      default = [{}];
      description = "clients for promtail";
    };
  };

  config.services.promtail = mkIf cfg.enable {
    enable = true;
    configuration = {
      inherit (cfg) clients;
      server.disable = true;

      scrape_configs = [
        {
          job_name = "journal";

          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "${config.networking.hostName}";
            };
          };

          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
