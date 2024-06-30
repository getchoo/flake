{ config, lib, ... }:
let
  cfg = config.seth;
in
{
  options.seth = {
    enable = lib.mkEnableOption "Seth's home configuration";
  };

  imports = [ ./standalone.nix ];

  config = lib.mkIf cfg.enable { home.stateVersion = "23.11"; };
}
