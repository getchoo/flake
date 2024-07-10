{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      projectRootFile = ".git/config";

      # TODO: add actionlint
      # https://github.com/numtide/treefmt-nix/pull/146
      programs = {
        deadnix.enable = true;
        just.enable = true;
        nixfmt.enable = true;
        statix.enable = true;
      };
    };
  };
}
