{
  perSystem = {config, ...}: {
    pre-commit = {
      settings.hooks = {
        actionlint.enable = true;
        ${config.formatter.pname}.enable = true;
        deadnix.enable = true;
        nil.enable = true;
        statix.enable = true;
      };
    };
  };
}
