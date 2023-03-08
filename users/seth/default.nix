{
  config,
  pkgs,
  home-manager,
  ...
}: {
  users.users.seth = {
    extraGroups = ["wheel"];
    isNormalUser = true;
    hashedPassword = "***REMOVED***";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  home-manager.users.seth = let
    inherit (config.nixpkgs) overlays;
  in {
    imports = [
      ./home.nix
    ];
    nixpkgs.overlays = overlays;
  };
}
