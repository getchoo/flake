{
  imports = [./system.nix];

  home-manager.users.seth = {
    seth.desktop.enable = false;
  };
}
