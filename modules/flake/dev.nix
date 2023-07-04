{
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    checks = {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = self;
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
        packages = with pkgs;
        with inputs; [
          actionlint
          alejandra
          deadnix
          just
          ragenix.packages.${system}.ragenix
          statix
          stylua
        ];
      };
    };

    formatter = pkgs.alejandra;
  };
}
