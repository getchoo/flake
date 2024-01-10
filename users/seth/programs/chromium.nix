{
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    inherit (config.desktop) enable;

    dictionaries = [pkgs.hunspellDictsChromium.en_US];

    extensions = [
      # ublock origin
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      # bitwarden
      {id = "nngceckbapebfimnlniiiahkandclblb";}
      # floccus bookmark sync
      {id = "fnaicdffflnofjppbagibeoednhnbjhg";}
      # tabby cat
      {id = "mefhakmgclhhfbdadeojlkbllmecialg";}
    ];
  };
}
