{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.features.tailscale;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.features.tailscale.enable = mkEnableOption "enable support for tailscale";

  config = mkIf cfg.enable {
    services = {
      openssh.openFirewall = false;
      tailscale.enable = mkDefault true;
    };

    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
      trustedInterfaces = mkDefault ["tailscale0"];
    };
  };
}
