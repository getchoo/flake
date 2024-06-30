{
  perSystem =
    { pkgs, ... }:
    {
      checks = {
        check-formatting =
          pkgs.runCommand "check-formatting" { nativeBuildInputs = [ pkgs.nixfmt-rfc-style ]; }
            ''
              cd ${./.}

              echo "running nixfmt..."
              nixfmt --check .

              touch $out
            '';

        check-lint =
          pkgs.runCommand "check-lint"
            {
              nativeBuildInputs = [
                pkgs.actionlint
                pkgs.deadnix
                pkgs.statix
              ];
            }
            ''
              cd ${./.}

              echo "running actionlint..."
              actionlint ./.github/workflows/*

              echo "running deadnix..."
              deadnix --fail

              echo "running statix..."
              statix check .

              touch $out
            '';
      };
    };
}
