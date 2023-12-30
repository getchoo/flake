{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.server.services.cloudflared;
  inherit (lib) mkEnableOption mkIf;
  inherit (config.services) nginx;
in {
  options.server.services.cloudflared = {
    enable = mkEnableOption "cloudflared";
  };

  config = mkIf cfg.enable {
    age.secrets.cloudflaredCreds = {
      file = secretsDir + "/cloudflaredCreds.age";
      mode = "400";
      owner = "cloudflared";
      group = "cloudflared";
    };

    services.cloudflared = {
      enable = true;
      tunnels = {
        "${config.networking.hostName}-nginx" = {
          default = "http_status:404";

          ingress = lib.genAttrs (builtins.attrNames nginx.virtualHosts) (
            _: {service = "http://localhost:${toString nginx.defaultHTTPListenPort}";}
          );

          credentialsFile = config.age.secrets.cloudflaredCreds.path;
        };
      };
    };
  };
}
