{ config, lib, ... }:
let
  cfg = config.server.mixins.promtail;
  inherit (lib) types;
in
{
  options.server.mixins.promtail = {
    enable = lib.mkEnableOption "Promtail mixin";

    clients = lib.mkOption {
      type = types.listOf types.attrs;
      default = [ { } ];
      description = "Clients for promtail";
    };
  };

  config = lib.mkIf cfg.enable {
    services.promtail = {
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
                source_labels = [ "__journal__systemd_unit" ];
                target_label = "unit";
              }
            ];
          }
        ];
      };
    };
  };
}
