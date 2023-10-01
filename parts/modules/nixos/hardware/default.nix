{
  config,
  lib,
  ...
}: let
  cfg = config.hardware;
  inherit (lib) mkEnableOption mkIf;
in {
  options.hardware.enable = mkEnableOption "hardware module";

  imports = [
    ./ssd.nix
    ./nvidia.nix
  ];

  config = mkIf cfg.enable {
    hardware.enableAllFirmware = true;
  };
}
