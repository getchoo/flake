{ config, lib, ... }:
let
  cfg = config.base;
in
{
  imports = [
    ../../shared
    ./programs.nix
  ];

  config = lib.mkIf cfg.enable { services.nix-daemon.enable = true; };
}
