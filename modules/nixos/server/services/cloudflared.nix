{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.server.services.cloudflared;
  inherit (lib) mkEnableOption mkIf;
in {
  options.server.services.cloudflared = {
    enable = mkEnableOption "cloudflared";
  };

  config = mkIf cfg.enable {
    age.secrets.cloudflaredCreds = {
      file = "${self}/secrets/hosts/${config.networking.hostName}/cloudflaredCreds.age";
      mode = "400";
      owner = "cloudflared";
      group = "cloudflared";
    };

    services.cloudflared = {
      enable = true;
      tunnels = {
        "${config.networking.hostName}-nginx" = {
          default = "http_status:404";

          ingress = let
            inherit (config.services) nginx;
          in
            lib.genAttrs
            (builtins.attrNames nginx.virtualHosts)
            (_: {service = "http://localhost:${builtins.toString nginx.defaultHTTPListenPort}";});

          originRequest.noTLSVerify = true;
          credentialsFile = config.age.secrets.cloudflaredCreds.path;
        };
      };
    };
  };
}
