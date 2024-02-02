{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
in {
  options.desktop.enable = lib.mkEnableOption "base desktop settings";

  imports = [
    ./budgie
    ./gnome
    ./plasma
  ];

  config = lib.mkIf cfg.enable {
    environment = {
      noXlibs = lib.mkForce false;
      systemPackages = with pkgs; [wl-clipboard xclip];
    };

    fonts = {
      enableDefaultPackages = lib.mkDefault true;

      packages = with pkgs; [
        (nerdfonts.override {fonts = ["FiraCode" "Hack" "Noto"];})
        noto-fonts
        noto-fonts-extra
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
      ];

      fontconfig = {
        enable = lib.mkDefault true;
        cache32Bit = true;
        defaultFonts = lib.mkDefault {
          serif = ["Noto Serif"];
          sansSerif = ["Noto Sans"];
          emoji = ["Noto Color Emoji"];
          monospace = ["Noto Sans Mono"];
        };
      };
    };

    hardware.pulseaudio.enable = false;

    programs = {
      chromium.enable = lib.mkDefault true;
      firefox.enable = lib.mkDefault true;
      xwayland.enable = lib.mkDefault true;
    };

    services = {
      pipewire = lib.mkDefault {
        enable = true;
        wireplumber.enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };

      xserver.enable = lib.mkDefault true;
    };

    xdg.portal.enable = lib.mkDefault true;
  };
}
