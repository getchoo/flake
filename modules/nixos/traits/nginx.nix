{
  config,
  lib,
  ...
}: let
  cfg = config.traits.nginx;
in {
  options.traits.nginx = {
    defaultConfiguration = lib.mkEnableOption "default nginx configuration";
  };

  config = lib.mkIf cfg.defaultConfiguration {
    services.nginx = {
      enable = true;

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedZstdSettings = true;
    };
  };
}
