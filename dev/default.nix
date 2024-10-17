{
  imports = [
    ./checks.nix
    ./hydra.nix
    ./shells.nix
  ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-rfc-style;
    };
}
