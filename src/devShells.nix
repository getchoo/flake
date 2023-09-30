{
  self',
  agenix,
  root,
  ...
}: let
  inherit (root.utils) forAllSystems getSystem;
  isLinux = pkgs: pkgs.stdenv.hostPlatform.isLinux;
in
  forAllSystems (pkgs: {
    default = pkgs.mkShell {
      shellHook = ''
        ${self'.checks.${getSystem pkgs}.pre-commit.shellHook}
      '';
      packages =
        (with pkgs; [
          actionlint
          alejandra
          deadnix
          just
          statix
          stylua
        ])
        ++ pkgs.lib.optional (isLinux pkgs) agenix.packages.${getSystem pkgs}.agenix;
    };
  })
