{
  perSystem =
    {
      lib,
      pkgs,
      self',
      inputs',
      ...
    }:
    {
      devShells =
        let
          nixos-rebuild = pkgs.nixos-rebuild.override { nix = pkgs.lix; };
          inherit (inputs'.nix-darwin.packages) darwin-rebuild;
        in
        {
          default = pkgs.mkShellNoCC {
            packages =
              [
                # For CI
                pkgs.actionlint

                # Nix tools
                pkgs.nil
                pkgs.statix
                self'.formatter

                pkgs.just
              ]
              ++ lib.optional pkgs.stdenv.isDarwin darwin-rebuild # See next comment
              ++ lib.optionals pkgs.stdenv.isLinux [
                # We want to make sure we have the same
                # Nix behavior across machines
                pkgs.lix

                # Ditto
                nixos-rebuild

                inputs'.agenix.packages.agenix
              ];
          };
        };

    };
}
