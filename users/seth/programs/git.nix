{
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    extraConfig = {
      init = {defaultBranch = "main";};
    };

    signing = {
      key = "D31BD0D494BBEE86";
      signByDefault = true;
    };

    userEmail = "getchoo@tuta.io";
    userName = "seth";
  };

  services.gpg-agent.extraConfig = lib.optionalString pkgs.stdenv.isLinux ''
    pinentry-program /run/current-system/sw/bin/pinentry
  '';
}
