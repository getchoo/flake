{ pkgs
, desktop
, ...
}:
let
  gui = desktop != "";
  pinentry = with pkgs;
    if desktop == "gnome"
    then pinentry-gnome
    else pinentry-curses;
in
{
  environment.systemPackages = with pkgs;
    [
      neofetch
      python311
    ]
    ++ [ pinentry ];

  programs = {
    firefox.enable = if gui then true else false;
    git.enable = true;
    gnupg = {
      agent = {
        enable = true;
        pinentryFlavor =
          if desktop == "gnome"
          then "gnome3"
          else "curses";
      };
    };
    vim.defaultEditor = true;
  };
}
