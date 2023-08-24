{withSystem, ...} @ args: {
  flake.lib = {
    configs = import ./configs.nix args;
    utils = import ./utils ({inherit withSystem;} // args);
  };
}
