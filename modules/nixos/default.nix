{
  flake.nixosModules = {
    default = ./base.nix;
    desktop = ./desktop;
    features = ./features;
    gnome = ./desktop/gnome;
    plasma = ./desktop/plasma;
    budgie = ./desktop/budgie;
    server = ./server;
    services = ./services;
    sway = ./desktop/sway;
  };
}
