{
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        prettier.enable = true;
      };

      settings.global = {
        excludes = [
          "./flake.lock"
        ];
      };
    };
  };
}
