{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.pre-commit.flakeModule
  ];

  perSystem = {
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
        stylua.enable = true;
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
            just
            statix
            stylua
          ]
          ++ lib.optional stdenv.isLinux inputs'.agenix.packages.agenix;
      };
    };

    formatter = pkgs.alejandra;
  };
}
