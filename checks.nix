{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    checks = {
      inherit
        (inputs.flake-checks.lib.mkChecks {
          inherit pkgs;
          root = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.gitTracked ./.;
          };
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
