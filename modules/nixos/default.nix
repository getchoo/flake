{
  flake.nixosModules = {
    default = ./base.nix;
    desktop = ./desktop;
    features = ./features;
    server = ./server;
    services = ./services;
    sway = ./desktop/sway;
  };
}
