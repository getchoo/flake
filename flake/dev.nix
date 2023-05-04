{
  self,
  inputs,
  ...
}: let
  inherit (inputs) pre-commit-hooks ragenix;
in {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    checks = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          actionlint.enable = true;
          alejandra.enable = true;
          deadnix.enable = true;
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
          ragenix.packages.${system}.ragenix
          alejandra
          deadnix
          fzf
          git-crypt
          just
          statix
          stylua
        ];
      };
    };

    formatter = pkgs.alejandra;
  };
}
