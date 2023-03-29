{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cachix
    hyfetch
    neofetch
    pinentry-curses
    python311
  ];

  programs = {
    git.enable = true;
    gnupg = {
      agent = {
        enable = true;
        pinentryFlavor = lib.mkDefault "curses";
      };
    };
    vim.defaultEditor = true;
  };
}
