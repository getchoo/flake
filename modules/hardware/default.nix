{
  config,
  lib,
  ...
}: let
  cfg = config.myHardware;
  inherit (lib) mkEnableOption mkIf;
in {
  options.myHardware.enable = mkEnableOption "hardware module";

  imports = [
    ./nvidia.nix
  ];

  config = mkIf cfg.enable {
    hardware.enableAllFirmware = true;
  };
}
