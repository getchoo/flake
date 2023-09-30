{
  config,
  lib,
  pkgs,
  inputs,
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
      hashedPasswordFile = config.age.secrets.sethPassword.path;
    });

  programs.fish.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = inputs // {inherit inputs;};
  };

  home-manager.users.seth = {
    imports = [
      ./home.nix
    ];

    nixpkgs.overlays = config.nixpkgs.overlays;
  };
}
