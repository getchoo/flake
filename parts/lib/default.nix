args: {
  flake.lib = {
    configs = import ./configs.nix args;
    utils = {
      nginx = import ./utils/nginx.nix args;
    };
  };
}
