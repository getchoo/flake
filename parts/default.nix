{
  imports = [
    ./lib
    ./modules
    ./overlays
    ./systems
    ./users
    ./dev.nix
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
}
