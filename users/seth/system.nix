{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.seth =
    {
      shell = pkgs.fish;
      home =
        if pkgs.stdenv.isDarwin
        then "/Users/seth"
        else "/home/seth";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      extraGroups = ["wheel"];
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.sethPassword.path;
    };

  programs.fish.enable = true;

  home-manager.users.seth = {
    imports =
      [
        ./.
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        ./desktop
        ./programs/chromium.nix
        ./programs/firefox
        ./programs/mangohud.nix
        ./programs/vscode.nix
      ];
  };
}
