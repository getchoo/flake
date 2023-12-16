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
        ${config.formatter.pname}.enable = true;
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

    formatter = pkgs.alejandra;
  };
}
