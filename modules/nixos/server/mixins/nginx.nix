{ config, lib, ... }:
let
  cfg = config.server.mixins.nginx;
in
{
  options.server.mixins.nginx = {
    enable = lib.mkEnableOption "NGINX mixin";
  };

  config = lib.mkIf cfg.enable {
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
