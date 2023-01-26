{
  config,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ../common
    ../../users/seth
  ];

  sys.wsl.enable = true;

  # enable non-free packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "22.11";
}
