{
  perSystem =
    {
      lib,
      pkgs,
      inputs',
      self',
      ...
    }:
    let
      nixos-rebuild = pkgs.nixos-rebuild.override { nix = pkgs.lix; };
      darwin-rebuild = inputs'.nix-darwin.packages.darwin-rebuild.override { nix = pkgs.lix; };
    in
    {
      devShells.default = pkgs.mkShellNoCC {
        packages =
          [
            # we want to make sure we have the same
            # nix behavior across machines
            pkgs.lix

            # format + lint
            pkgs.actionlint
            self'.formatter
            pkgs.nixfmt-rfc-style
            pkgs.nil
            pkgs.statix

            # utils
            pkgs.fzf # for just
            pkgs.just

            # terranix
            self'.packages.opentofu
          ]
          ++ lib.optional pkgs.stdenv.isDarwin darwin-rebuild # see above comment about {l,n}ix
          ++ lib.optionals pkgs.stdenv.isLinux [
            nixos-rebuild # ditto
            inputs'.agenix.packages.agenix
          ];
      };
    };
}
