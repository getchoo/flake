{
  perSystem = {
    pkgs,
    config,
    inputs',
    self',
    ...
  }: {
    devShells = {
      default = pkgs.mkShellNoCC {
        shellHook = config.pre-commit.installationScript;
        packages = with pkgs;
          [
            actionlint

            # nix
            self'.formatter
            deadnix
            nil
            statix

            # utils
            deploy-rs
            fzf
            just
            config.terranix.package
          ]
          ++ lib.optional stdenv.isLinux inputs'.agenix.packages.agenix;
      };
    };
  };
}
