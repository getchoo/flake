{ lib, ... }:
{
  imports = [
    ./nix.nix
    ./programs.nix
    ./security.nix
    ./users.nix
  ];

  documentation.nixos.enable = lib.mkDefault false;
}
