{
  config,
  pkgs,
  home-manager,
  ...
}: {
  users.users.seth = {
    extraGroups = ["wheel"];
    isNormalUser = true;
    shell = pkgs.fish;
    passwordFile = config.age.secrets.sethPassword.path;
  };

  programs.fish.enable = true;
  nix.settings.trusted-users = ["seth"];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.seth = let
    inherit (config.nixpkgs) overlays;
  in {
    imports = [
      ./home.nix
    ];
    nixpkgs.overlays = overlays;
  };
}
