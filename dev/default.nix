{
  imports = [
    ./checks.nix
    ./ci.nix
    ./shell.nix
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
