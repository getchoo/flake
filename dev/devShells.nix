{
  perSystem =
    {
      lib,
      pkgs,
      inputs',
      self',
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          packages =
            [
              # we want to make sure we have the same
              # nix behavior across machines
              pkgs.lix

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

              # terranix
              self'.packages.opentofu
            ]
            # see above comment about {l,n}ix
            ++ lib.optional pkgs.stdenv.isDarwin inputs'.nix-darwin.packages.darwin-rebuild
            ++ lib.optionals pkgs.stdenv.isLinux [
              pkgs.nixos-rebuild # ditto
              inputs'.agenix.packages.agenix
            ];
        };
      };
    };
}
