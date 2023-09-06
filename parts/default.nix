_: {
  imports = [
    ./deploy.nix
    ./dev.nix
    ./lib
    ./overlays
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
}
