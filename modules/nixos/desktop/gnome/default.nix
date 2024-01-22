{pkgs, ...}: {
  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-tour
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      adw-gtk3
      blackbox-terminal
    ];
  };

  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
