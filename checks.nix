{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    checks = {
      inherit
        (inputs.flake-checks.lib.mkChecks {
          root = ../.;
          inherit pkgs;
        })
        actionlint
        alejandra
        deadnix
        editorconfig
        statix
        ;
    };
  };
}
