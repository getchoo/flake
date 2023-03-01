{
  pkgs,
  desktop,
  ...
}: {
  imports =
    [
      ../programs/mangohud.nix
      ../programs/firefox.nix
    ]
    ++ (
      if (desktop == "gnome")
      then [./gnome.nix]
      else []
    )
    ++ (
      if (desktop == "plasma")
      then [./plasma.nix]
      else []
    );

  home.packages = with pkgs; [
    discord-canary
    element-desktop
    spotify
    steam
  ];
}
