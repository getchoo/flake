{
  self,
  inputs,
  ...
}: let
  inherit (inputs) nil pre-commit-hooks ragenix;
in {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    checks = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./..;
        hooks = {
          actionlint.enable = true;
          alejandra.enable = true;
          deadnix.enable = true;
          nil.enable = true;
          statix.enable = true;
          stylua.enable = true;
        };
      };
    };

    devShells = let
      inherit (pkgs) mkShell;
    in {
      default = mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = with pkgs; [
          actionlint
          alejandra
          deadnix
          just
          nil.packages.${system}.nil
          ragenix.packages.${system}.ragenix
          statix
          stylua
        ];
      };
    };

    formatter = pkgs.alejandra;
  };
}
