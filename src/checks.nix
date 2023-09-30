{
  pre-commit,
  root,
  ...
}: let
  inherit (root.utils) forAllSystems getSystem;
in
  forAllSystems (pkgs: {
    pre-commit = pre-commit.lib.${getSystem pkgs}.run {
      src = ../.;
      hooks = {
        actionlint.enable = true;
        alejandra.enable = true;
        deadnix.enable = true;
        nil.enable = true;
        statix.enable = true;
        stylua.enable = true;
      };
    };
  })
