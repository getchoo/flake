{ config, inputs, ... }:
let
  inherit (inputs.self.lib.nginx) mkProxy toVHosts;
in
{
  services.nginx = {
    virtualHosts = toVHosts config.networking.domain {
      miniflux = {
        locations = mkProxy "/" "7000";
      };
    };
  };
}
