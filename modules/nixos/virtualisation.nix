{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixos.virtualisation;
  inherit (lib) mkEnableOption mkIf;
in {
  options.nixos.virtualisation.enable = mkEnableOption "enable podman";

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        enableNvidia = true;
        extraPackages = with pkgs; [podman-compose];
        autoPrune.enable = true;
      };
      oci-containers.backend = "podman";
    };
  };
}
