{
  pkgs,
  lib,
  ...
}: {
  environment = {
    gnome.excludePackages = with pkgs; [
      epiphany
      gnome-tour
    ];
    systemPackages = with pkgs; [
      adw-gtk3
      blackbox-terminal
    ];
  };

  services.xserver = {
    displayManager.gdm = {
      enable = true;
      wayland = lib.mkForce true;
    };
    desktopManager.gnome.enable = true;
  };
}
