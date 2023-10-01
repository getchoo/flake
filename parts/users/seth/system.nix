{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.seth = let
    inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  in
    lib.recursiveUpdate
    {
      shell = pkgs.fish;
      home =
        if isDarwin
        then "/Users/seth"
        else "/home/seth";
    }
    (lib.optionalAttrs isLinux {
      extraGroups = ["wheel"];
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.sethPassword.path;
    });

  programs.fish.enable = true;

  home-manager.users.seth = {
    imports = [./.];
    nixpkgs.overlays = config.nixpkgs.overlays;
  };
}
