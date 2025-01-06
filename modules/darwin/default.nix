{
  flake.darwinModules = {
    default = {
      imports = [
        ../shared
        ./defaults
        ./desktop
        ./profiles
        ./traits
      ];
    };
  };
}
