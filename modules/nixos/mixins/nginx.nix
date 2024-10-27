{ config, lib, ... }:
let
  cfg = config.mixins.nginx;
in
{
  options.mixins.nginx = {
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
