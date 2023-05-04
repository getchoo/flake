{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.hardware;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.hardware.enable = mkEnableOption "hardware module";

  imports = [
    ./nvidia.nix
  ];

  config = mkIf cfg.enable {
    hardware.enableAllFirmware = true;
  };
}
