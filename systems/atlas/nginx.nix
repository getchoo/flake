{
  config,
  inputs,
  ...
}: let
  inherit (inputs.self.lib.nginx) mkProxy toVHosts;

  miniflux = {
    locations = mkProxy "/" "7000";
  };
in {
  services.nginx = {
    virtualHosts =
      toVHosts config.networking.domain {
        inherit miniflux;
      }
      // toVHosts "mydadleft.me" {
        inherit miniflux;
      };
  };
}
