{ pkgs
, desktop
, ...
}:
let
  gui = desktop != "";
  pinentry =
    if desktop == "gnome"
    then pkgs.pinentry-gnome
    else pkgs.pinentry-curses;
in
{
  environment.systemPackages = with pkgs;
    [
      git
      neofetch
      python311
      vim
    ]
    ++ (
      if gui
      then with pkgs; [ firefox ]
      else [ ]
    )
    ++ [ pinentry ];

  programs = {
    gnupg = {
      agent = {
        enable = true;
        pinentryFlavor =
          if desktop == "gnome"
          then "gnome3"
          else "curses";
      };
    };
    zsh.enable = true;
  };
}
