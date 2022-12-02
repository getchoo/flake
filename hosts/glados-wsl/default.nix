{
  config,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ./packages.nix
    ../../users/seth
  ];

  # enable non-free packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "22.11";

  # hardware = {
  #   nvidia.package = boot.kernelPackages.nvidiaPackages.stable;
  #   xserver = {
  #     videoDrivers = [ "nvidia" ];
  #   };
  #   opengl.enable = true;
  # };

  networking.hostName = "glados-wsl";

  programs = {
    gnupg = {
      agent = {
        enable = true;
        pinentryFlavor = "curses";
      };
    };
  };
}
