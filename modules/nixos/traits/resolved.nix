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
        networking.nameservers = [
          "1.1.1.1#one.one.one.one"
          "1.0.0.1#one.one.one.one"
        ];

        services.resolved = {
          enable = true;
          dnsovertls = "true";
        };
      }

      (lib.mkIf cfg.networkManagerIntegration {
        networking.networkmanager.dns = "systemd-resolved";
      })
    ]
  );
}
