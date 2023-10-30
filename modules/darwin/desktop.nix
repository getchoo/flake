{
  lib,
  pkgs,
  ...
}: {
  fonts.fonts = with pkgs;
    lib.mkDefault [
      (nerdfonts.override {fonts = ["FiraCode"];})
    ];

  homebrew = {
    enable = lib.mkDefault true;
    caskArgs.require_sha = true;
    onActivation = lib.mkDefault {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    caskArgs = {
      no_quarantine = true;
    };

    casks = [
      "chromium"
    ];
  };

  programs.gnupg.agent.enable = lib.mkDefault true;
}
