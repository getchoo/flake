{pkgs, ...}: {
  imports = [
    ../.
  ];

  environment.systemPackages = with pkgs; [pinentry-qt];

  services.xserver = {
    displayManager.sddm.enable = true;
    desktopManager.plasma5 = {
      enable = true;
      excludePackages = with pkgs.libsForQt5; [
        khelpcenter
        plasma-browser-integration
        print-manager
      ];
      useQtScaling = true;
    };
  };

  programs.gnupg.agent.pinentryFlavor = "qt";
}
