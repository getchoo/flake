{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.traits.cloudflared;
  inherit (config.services) nginx;
in {
  options.traits.cloudflared = {
    enable = lib.mkEnableOption "cloudflared";
    manageSecrets =
      lib.mkEnableOption "automatically managed secrets"
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
