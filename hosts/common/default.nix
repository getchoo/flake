_: {
  imports = [
    ./documentation.nix
    ./desktop
    ./fonts.nix
    ./locale.nix
    ./packages.nix
    ./security.nix
    ./systemd.nix
    ./users.nix
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.warn-dirty = false;
  };
  # config.services.kmscon.enable = true;
}
