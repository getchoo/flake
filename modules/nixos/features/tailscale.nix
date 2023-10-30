{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.tailscale;
  inherit (lib) mkDefault mkEnableOption mkIf optionalAttrs;

  baseDir = ../../../secrets/systems/${config.networking.hostName};
in {
  options.features.tailscale = {
    enable = mkEnableOption "enable support for tailscale";
    ssh.enable = mkEnableOption "enable support for tailscale ssh";
  };

  config = mkIf cfg.enable {
    age.secrets = mkIf cfg.ssh.enable {
      tailscaleAuthKey.file = "${baseDir}/tailscaleAuthKey.age";
    };

    networking.firewall =
      {
        allowedUDPPorts = [config.services.tailscale.port];
        trustedInterfaces = ["tailscale0"];
      }
      // optionalAttrs cfg.ssh.enable {
        allowedTCPPorts = [22];
      };

    services = {
      tailscale.enable = mkDefault true;
    };

    # https://tailscale.com/kb/1096/nixos-minecraft/
    systemd.services = mkIf cfg.ssh.enable {
      tailscale-autoconnect = {
        description = "Automatic connection to Tailscale";

        after = ["network-pre.target" "tailscale.service"];
        wants = ["network-pre.target" "tailscale.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig.Type = "oneshot";

        script = ''
          # wait for tailscaled to settle
          sleep 2

          # check if we are already authenticated to tailscale
          status="$(${lib.getExe pkgs.tailscale} status -json | ${lib.getExe pkgs.jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          # otherwise authenticate with tailscale
          ${lib.getExe pkgs.tailscale}/bin/tailscale up --ssh \
            --auth-key "file:${config.age.secrets.tailscaleAuthKey.path}"
        '';
      };
    };
  };
}
