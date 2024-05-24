{moduleLocation, ...}: {
  flake = {
    darwinModules = builtins.mapAttrs (k: v: {
      _file = "${toString moduleLocation}#darwinModules.${k}";
      imports = [v];
    }) (import ./darwin);

    nixosModules = import ./nixos;
  };
}
