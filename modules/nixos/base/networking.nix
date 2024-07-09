{ config, lib, ... }:
let
  cfg = config.base.networking;
in
{
  options.base.networking = {
    enable = lib.mkEnableOption "base network settings" // {
      default = config.base.enable;
      defaultText = lib.literalExpression "config.base.enable";
    };
  };

  config = lib.mkIf cfg.enable {
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
