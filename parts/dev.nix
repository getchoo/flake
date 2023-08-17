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
            ragenix.packages.${system}.ragenix
            statix
            stylua
          ]
          ++ lib.optional (system == "x86_64-linux") pkgs.deploy-rs;
      };
    };

    formatter = pkgs.alejandra;
  };
}
