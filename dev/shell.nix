{
  perSystem = {
    pkgs,
    config,
    inputs',
    opentofu',
    ...
  }: {
    devShells = {
      default = pkgs.mkShell {
        shellHook = config.pre-commit.installationScript;
        packages = with pkgs;
          [
            actionlint

            # nix
            config.formatter
            deadnix
            nil
            statix

            # utils
            deploy-rs
            fzf
            just
            opentofu' # see ../terranix/
          ]
          ++ lib.optional stdenv.isLinux inputs'.agenix.packages.agenix;
      };
    };
  };
}
