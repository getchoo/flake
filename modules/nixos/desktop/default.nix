{
  lib,
  pkgs,
  ...
}: {
  environment = {
    noXlibs = lib.mkForce false;
    systemPackages = with pkgs; [wl-clipboard xclip];
  };

  fonts = {
    enableDefaultPackages = lib.mkDefault true;

    packages = with pkgs; [
      corefonts
      fira-code
      (nerdfonts.override {fonts = ["FiraCode" "Hack" "Noto"];})
      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
      noto-fonts-cjk-sans
    ];

    fontconfig = {
      enable = lib.mkDefault true;
      cache32Bit = true;
      defaultFonts = lib.mkDefault {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
        emoji = ["Noto Color Emoji"];
        monospace = ["Fira Code"];
      };
    };
  };

  hardware.pulseaudio.enable = false;

  programs = {
    dconf.enable = lib.mkDefault true;
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
}
