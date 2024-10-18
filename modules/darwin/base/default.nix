{ config, lib, ... }:
let
  cfg = config.base;
in
{
  imports = [
    ./programs.nix
  ];

  config = lib.mkIf cfg.enable { services.nix-daemon.enable = true; };
}
