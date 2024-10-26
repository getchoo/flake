{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  enable = osConfig.programs.niri.enable or false;
in
{
  config = lib.mkIf enable {
    # Set dark theme for Flatpak apps
    # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    # Required for adwaita-ize
    gtk.enable = true;

    home.packages = [
      # Torrent client
      pkgs.fragments

      # Mastodon client
      pkgs.tuba

      # the funni (I need it for native Wayland support)
      pkgs.vesktop

      # TODO: Figure out how to export $DISPLAY from this
      # so I don't need the above
      pkgs.xwayland-satellite
    ];

    # Enable things from the NixOS module here to
    # apply Catppuccin themes
    programs = {
      alacritty.enable = true;
      fuzzel.enable = true;
      mako.enable = true;
      swaylock.enable = true;
    };

    seth = {
      programs = {
        # Official Spotify has ugly CSD
        ncspot.enable = true;

        yazi.enable = true;
        zellij.enable = true;
      };

      # See comment about ncspot
      services.spotifyd.enable = true;

      tweaks = {
        adwaita-ize.enable = true;
      };
    };
  };
}
