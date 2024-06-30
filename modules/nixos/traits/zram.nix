{ config, lib, ... }:
let
  cfg = config.traits.zram;
in
{
  options.traits.zram = {
    enable = lib.mkEnableOption "zram setup & configuration";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/pop-os/default-settings/pull/163
    # https://wiki.archlinux.org/title/Zram#Multiple_zram_devices
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    zramSwap.enable = true;
  };
}
