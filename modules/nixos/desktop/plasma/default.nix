{pkgs, ...}: {
  environment = {
    plasma5.excludePackages = with pkgs.libsForQt5; [
      khelpcenter
      plasma-browser-integration
      print-manager
    ];
  };

  services.xserver = {
    displayManager.sddm.enable = true;
    desktopManager.plasma5 = {
      enable = true;
      useQtScaling = true;
    };
  };
}
