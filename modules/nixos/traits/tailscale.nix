{
  config,
  lib,
  secretsDir,
  ...
}:
let
  cfg = config.traits.tailscale;
in
{
  options.traits.tailscale = {
    enable = lib.mkEnableOption "Tailscale";
    ssh.enable = lib.mkEnableOption "Tailscale SSH";
    manageSecrets = lib.mkEnableOption "automatic secrets management" // {
      default = config.traits.secrets.enable && cfg.ssh.enable;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        networking.firewall = {
          trustedInterfaces = [ config.services.tailscale.interfaceName ];
        };

        services.tailscale = {
          enable = true;
          openFirewall = true;
        };
      }

      (lib.mkIf cfg.ssh.enable {
        networking.firewall = {
          allowedTCPPorts = [ 22 ];
        };

        services.tailscale = {
          extraUpFlags = [ "--ssh" ];
        };
      })

      (lib.mkIf cfg.manageSecrets {
        age.secrets = lib.mkIf cfg.manageSecrets {
          tailscaleAuthKey.file = "${secretsDir}/tailscaleAuthKey.age";
        };

        services.tailscale = {
          authKeyFile = config.age.secrets.tailscaleAuthKey.path;
        };
      })
    ]
  );
}
