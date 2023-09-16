{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) ragenix;
in {
  perSystem = {
    config,
    pkgs,
    system,
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
          ++ lib.optional pkgs.stdenv.isLinux ragenix.packages.${system}.ragenix;
      };
    };

    formatter = pkgs.alejandra;
  };
}
