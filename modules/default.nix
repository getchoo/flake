{
  flake = {
    darwinModules = {
      default = ./darwin;
    };

    nixosModules = {
      default = ./nixos;
    };
  };
}
