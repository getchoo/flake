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
            nix

            # format + lint
            actionlint
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
          ++ lib.optional stdenv.isDarwin [inputs'.darwin.packages.darwin-rebuild]
          ++ lib.optionals stdenv.isLinux [nixos-rebuild inputs'.agenix.packages.agenix];
      };
    };
  };
}
