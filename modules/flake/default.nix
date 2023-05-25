{inputs, ...}: {
  imports = [
    ./ci.nix
    ./dev.nix
  ];

  _module.args.myLib = inputs.getchoo.lib {
    inherit inputs;
  };

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
}
