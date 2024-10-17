{ self, ... }:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      mkCheck =
        {
          name,
          deps ? [ ],
          script,
        }:
        pkgs.runCommand name { nativeBuildInputs = deps; } ''
          ${script}
          touch $out
        '';
    in
    {
      checks = {
        actionlint = mkCheck {
          name = "check-actionlint";
          deps = [ pkgs.actionlint ];
          script = "actionlint ${self}/.github/workflows/**";
        };

        deadnix = mkCheck {
          name = "check-deadnix";
          deps = [ pkgs.deadnix ];
          script = "deadnix --fail ${self}";
        };

        just = mkCheck {
          name = "check-just";
          deps = [ pkgs.just ];
          script = ''
            cd ${self}
            just --check --fmt --unstable
            just --summary
          '';
        };

        nixfmt = mkCheck {
          name = "check-nixfmt";
          deps = [ pkgs.nixfmt-rfc-style ];
          script = "nixfmt --check ${self}";
        };

        statix = mkCheck {
          name = "check-statix";
          deps = [ pkgs.statix ];
          script = "statix check ${self}";
        };
      };
    };
}
