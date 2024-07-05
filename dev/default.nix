{
  imports = [
    ./checks.nix
    ./devShells.nix
    ./hydraJobs.nix
  ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-rfc-style;
    };
}
