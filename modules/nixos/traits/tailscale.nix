{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.traits.tailscale;
in {
  options.traits.tailscale = {
    enable = lib.mkEnableOption "Tailscale";
    ssh.enable = lib.mkEnableOption "Tailscale SSH";
    manageSecrets =
      lib.mkEnableOption "the use of agenix for auth"
      // {
        default = config.traits.secrets.enable && cfg.ssh.enable;
      };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      networking.firewall =
        {
          trustedInterfaces = ["tailscale0"];
        }
        // lib.optionalAttrs cfg.ssh.enable {
          allowedTCPPorts = [22];
        };

      services.tailscale =
        {
          enable = true;
          openFirewall = true;
        }
        // lib.optionalAttrs cfg.ssh.enable {
          extraUpFlags = ["--ssh"];
        }
        // lib.optionalAttrs cfg.manageSecrets {
          authKeyFile = config.age.secrets.tailscaleAuthKey.path;
        };
    }

    (lib.mkIf cfg.manageSecrets {
      age.secrets = lib.mkIf cfg.manageSecrets {
        tailscaleAuthKey.file = "${secretsDir}/tailscaleAuthKey.age";
      };
    })
  ]);
}
