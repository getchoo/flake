{
  config,
  lib,
  pkgs,
  nix-index-database,
  ...
}: {
  users.users.seth = let
    inherit (pkgs.stdenv) isLinux isDarwin;
  in
    lib.recursiveUpdate {
      shell = pkgs.fish;
      home = lib.optionalString (isLinux || isDarwin) (
        if isLinux
        then "/home/seth"
        else "/Users/seth"
      );
    } (lib.optionalAttrs pkgs.stdenv.isLinux {
      extraGroups = lib.optional pkgs.stdenv.isLinux "wheel";
      isNormalUser = true;
      passwordFile = config.age.secrets.sethPassword.path;
    });

  programs.fish.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.seth = {
    imports = [
      ./home.nix
      ./module.nix
      nix-index-database.hmModules.nix-index
    ];

    nixpkgs.overlays = config.nixpkgs.overlays;
  };
}
