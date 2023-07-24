{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./shell
  ];

  home = let
    username = "seth";
    inherit (pkgs.stdenv) isLinux isDarwin;
    optionalLinuxDarwin = lib.optionalString (isLinux || isDarwin);
  in {
    inherit username;
    homeDirectory = optionalLinuxDarwin (
      if isLinux
      then "/home/${username}"
      else "/Users/${username}"
    );

    stateVersion = "23.11";
  };
}
