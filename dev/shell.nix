{
  perSystem = {
    pkgs,
    config,
    inputs',
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
            jq
            opentofu
          ]
          ++ lib.optional stdenv.isLinux inputs'.agenix.packages.agenix;
      };
    };
  };
}
