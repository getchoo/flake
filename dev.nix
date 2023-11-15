{
  perSystem = {
    lib,
    pkgs,
    config,
    inputs',
    ...
  }: {
    pre-commit = {
      settings.hooks = {
        actionlint.enable = true;
        alejandra.enable = true;
        deadnix.enable = true;
        nil.enable = true;
        statix.enable = true;
      };
    };

    devShells = {
      default = pkgs.mkShell {
        shellHook = config.pre-commit.installationScript;
        packages = with pkgs;
          [
            actionlint
            alejandra
            deadnix
            fzf
            just
            nil
            statix
          ]
          ++ lib.optional stdenv.isLinux inputs'.agenix.packages.agenix;
      };
    };

    formatter = pkgs.alejandra;
  };
}
