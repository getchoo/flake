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
      # Media player
      pkgs.celluloid

      # PDF reader
      pkgs.evince

      # Torrent client
      pkgs.fragments

      # Image viewer
      pkgs.loupe

      # Mastodon client
      pkgs.tuba

      # the funni (I need it for native Wayland support)
      pkgs.vesktop

      # TODO: Figure out how to export $DISPLAY from this
      # so I don't need the above
      pkgs.xwayland-satellite
    ];

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
