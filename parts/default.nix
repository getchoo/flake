{inputs, ...}: {
  imports = [
    ./ci.nix
    ./dev.nix
    ./overlays
  ];

  _module.args.myLib = inputs.getchoo.lib;

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
}
