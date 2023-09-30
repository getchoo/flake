{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.features.tailscale;
  inherit (lib) mkDefault mkEnableOption mkIf optionalAttrs;
in {
  options.features.tailscale = {
    enable = mkEnableOption "enable support for tailscale";
    ssh.enable = mkEnableOption "enable support for tailscale ssh";
  };

  config = mkIf cfg.enable {
    age.secrets = let
      baseDir = "${self}/src/_secrets/hosts/${config.networking.hostName}";
    in
      mkIf cfg.ssh.enable {
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

        script = let
          inherit (pkgs) tailscale jq;
        in ''
          # wait for tailscaled to settle
          sleep 2

          # check if we are already authenticated to tailscale
          status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          # otherwise authenticate with tailscale
          ${tailscale}/bin/tailscale up --ssh \
            --auth-key "file:${config.age.secrets.tailscaleAuthKey.path}"
        '';
      };
    };
  };
}
