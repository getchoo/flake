{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.getchoo.features.tailscale;
  inherit (lib) mkDefault mkEnableOption mkIf optionalString;
in {
  options.getchoo.features.tailscale = {
    enable = mkEnableOption "enable support for tailscale";
    ssh.enable = mkEnableOption "enable support for tailscale ssh";
  };

  config = mkIf cfg.enable {
    age.secrets = let
      baseDir = "${self}/secrets/hosts/${config.networking.hostName}";
    in
      mkIf cfg.ssh.enable {
        tailscaleAuthKey.file = "${baseDir}/tailscaleAuthKey.age";
      };

    networking.firewall =
      {
        allowedUDPPorts = [config.services.tailscale.port];
        trustedInterfaces = ["tailscale0"];
      }
      // lib.optionalAttrs cfg.ssh.enable {
        allowedTCPPorts = [22];
      };

    services = {
      tailscale.enable = mkDefault true;
    };

    # https://tailscale.com/kb/1096/nixos-minecraft/
    systemd.services.tailscale-autoconnect = {
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
        ${tailscale}/bin/tailscale up ${optionalString cfg.ssh.enable "--ssh"} \
          --auth-key "file:${config.age.secrets.tailscaleAuthKey.path}"
      '';
    };
  };
}
