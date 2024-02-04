{
  perSystem = {self', ...}: {
    pre-commit = {
      settings.hooks = {
        actionlint.enable = true;
        ${self'.formatter.pname}.enable = true;
        deadnix.enable = true;
        nil.enable = true;
        statix.enable = true;
      };
    };
  };
}
