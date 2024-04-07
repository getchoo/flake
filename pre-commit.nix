{
  perSystem = {config, ...}: {
    pre-commit.settings.hooks = {
      actionlint.enable = true;

      treefmt = {
        enable = true;
        package = config.treefmt.build.wrapper;
      };

      nil.enable = true;
      statix.enable = true;
    };
  };
}
