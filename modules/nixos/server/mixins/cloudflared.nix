{
  config,
  lib,
  secretsDir,
  ...
}:
let
  cfg = config.server.mixins.cloudflared;
  inherit (config.services) nginx;
in
{
  options.server.mixins.cloudflared = {
    enable = lib.mkEnableOption "cloudflared mixin";
    tunnelName = lib.mkOption {
      type = lib.types.str;
      default = "${config.networking.hostName}-nginx";
      example = lib.literalExpression "my-tunnel";
      description = lib.mdDoc ''
        Name of the default tunnel being created
      '';
    };

    manageSecrets = lib.mkEnableOption "automatic secrets management" // {
      default = config.traits.secrets.enable;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.cloudflared = {
          enable = true;
          tunnels.${cfg.tunnelName} = {
            default = "http_status:404";

            ingress = lib.mapAttrs (_: _: {
              service = "http://localhost:${toString nginx.defaultHTTPListenPort}";
            }) nginx.virtualHosts;
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

        services.cloudflared.tunnels.${cfg.tunnelName} = {
          credentialsFile = config.age.secrets.cloudflaredCreds.path;
        };
      })
    ]
  );
}
