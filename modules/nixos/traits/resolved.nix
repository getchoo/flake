{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.resolved;
in
{
  options.traits.resolved = {
    enable = lib.mkEnableOption "systemd-resolved as the DNS resolver" // {
      default = true;
    };

    networkManagerIntegration = lib.mkEnableOption "integration with network-manager" // {
      default = config.networking.networkmanager.enable;
      defaultText = "config.networking.networkmanager.enable";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.resolved = {
          enable = true;
          dnssec = "allow-downgrade";
          extraConfig = ''
            [Resolve]
            DNS=1.1.1.1 1.0.0.1
            DNSOverTLS=yes
          '';
        };
      }

      (lib.mkIf cfg.networkManagerIntegration {
        networking.networkmanager.dns = "systemd-resolved";
      })
    ]
  );
}
