{withSystem, ...} @ args: {
  flake.lib = {
    configs = import ./configs.nix args;
    utils = import ./utils.nix ({inherit withSystem;} // args);
  };
}
