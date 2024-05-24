{
  perSystem = {
    lib,
    pkgs,
    inputs',
    self',
    ...
  }: {
    devShells = {
      default = pkgs.mkShellNoCC {
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
            self'.packages.opentofu
          ]
          ++ lib.optional pkgs.stdenv.isDarwin [inputs'.nix-darwin.packages.darwin-rebuild]
          ++ lib.optionals pkgs.stdenv.isLinux [pkgs.nixos-rebuild inputs'.agenix.packages.agenix];
      };
    };
  };
}
