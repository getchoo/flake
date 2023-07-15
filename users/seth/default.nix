{
  config,
  pkgs,
  ...
}: {
  users.users.seth = {
    extraGroups = ["wheel"];
    isNormalUser = true;
    shell = pkgs.fish;
    passwordFile = config.age.secrets.sethPassword.path;
  };

  programs.fish.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.seth = {
    imports = [
      ./home.nix
      ./desktop
    ];

    nixpkgs.overlays = config.nixpkgs.overlays;
  };
}
