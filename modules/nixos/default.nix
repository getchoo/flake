{
  flake.nixosModules = {
    default = ./base.nix;
    desktop = ./desktop;
    gnome = ./desktop/gnome;
    plasma = ./desktop/plasma;
    budgie = ./desktop/budgie;
    server = ./server;
    services = ./services;
    hardware = ./hardware;
  };
}
