{ config, lib, ... }:
let
  cfg = config.base.networking;
  enable = config.base.enable && cfg.enable;
in
{
  options.base.networking = {
    enable = lib.mkEnableOption "base network settings" // {
      default = true;
    };
  };

  config = lib.mkIf enable {
    networking.networkmanager = {
      enable = lib.mkDefault true;
      dns = "systemd-resolved";
    };

    services = {
      resolved = {
        enable = lib.mkDefault true;
        dnssec = "allow-downgrade";
        extraConfig = lib.mkDefault ''
          [Resolve]
          DNS=1.1.1.1 1.0.0.1
          DNSOverTLS=yes
        '';
      };
    };
  };
}
