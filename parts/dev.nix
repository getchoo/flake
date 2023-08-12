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

    devShells = {
      default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = with pkgs;
          [
            actionlint
            alejandra
            deadnix
            just
            inputs.ragenix.packages.${system}.ragenix
            statix
            stylua
          ]
          ++ lib.optional (system == "x86_64-linux") deploy-rs;
      };
    };

    formatter = pkgs.alejandra;
  };
}
