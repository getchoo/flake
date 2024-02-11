{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.server.mixins.cloudflared;
  inherit (config.services) nginx;
in {
  options.server.mixins.cloudflared = {
    enable = lib.mkEnableOption "cloudflared mixin";
    manageSecrets =
      lib.mkEnableOption "automatic secrets management"
      // {
        default = config.traits.secrets.enable;
      };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.cloudflared = {
          enable = true;
          tunnels = {
            "${config.networking.hostName}-nginx" =
              {
                default = "http_status:404";

                ingress = lib.genAttrs (builtins.attrNames nginx.virtualHosts) (
                  _: {service = "http://localhost:${toString nginx.defaultHTTPListenPort}";}
                );
              }
              // lib.optionalAttrs cfg.manageSecrets {
                credentialsFile = config.age.secrets.cloudflaredCreds.path;
              };
          };
        };
      }

      (lib.mkIf cfg.manageSecrets {
        age.secrets.cloudflaredCreds = {
          file = secretsDir + "/cloudflaredCreds.age";
          mode = "400";
          owner = "cloudflared";
          group = "cloudflared";
        };
      })
    ]
  );
}
