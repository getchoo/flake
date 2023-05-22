{
  inputs,
  self,
  ...
}: {
  imports = [
    ./ci.nix
    ./dev.nix
  ];

  _module.args.myLib = self.lib {
    inherit inputs;
    inherit (inputs.nixpkgs) lib;
  };

  flake = {
    lib = import ../../lib;
  };

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
}
