{
  imports = [
    ./ci.nix
    ./dev-shell.nix
  ];

  perSystem =
    { pkgs, ... }:

    {
      formatter = pkgs.nixfmt-rfc-style;
    };
}
