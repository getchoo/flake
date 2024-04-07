{
  perSystem = {
    config,
    lib,
    pkgs,
    inputs',
    self',
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      shellHook = config.pre-commit.installationScript;
      packages =
        [
          pkgs.nix

          # format + lint
          pkgs.actionlint
          self'.formatter
          pkgs.deadnix
          pkgs.nil
          pkgs.statix

          # utils
          pkgs.deploy-rs
          pkgs.fzf
          pkgs.just
          config.terranix.package
        ]
        ++ lib.optional pkgs.stdenv.isDarwin [inputs'.darwin.packages.darwin-rebuild]
        ++ lib.optionals pkgs.stdenv.isLinux [pkgs.nixos-rebuild inputs'.agenix.packages.agenix];
    };
  };
}
