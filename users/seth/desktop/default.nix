{ pkgs
, desktop
, ...
}: {
  imports =
    [
      ../programs/mangohud.nix
    ]
    ++ (
      if (desktop == "gnome")
      then [ ./gnome.nix ]
      else [ ./plasma.nix ]
    );

  home.packages = with pkgs; [
    discord
    element-desktop
    spotify
    steam
  ];
}
