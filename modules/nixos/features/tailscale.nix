{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.features.tailscale;
in {
  options.features.tailscale = {
    enable = lib.mkEnableOption "enable support for tailscale";
    ssh.enable = lib.mkEnableOption "enable support for tailscale ssh";
  };

  config = lib.mkIf cfg.enable {
    age.secrets = lib.mkIf cfg.ssh.enable {
      tailscaleAuthKey.file = "${secretsDir}/tailscaleAuthKey.age";
    };

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
        authKeyFile = config.age.secrets.tailscaleAuthKey.path;
        extraUpFlags = ["--ssh"];
      };
  };
}
