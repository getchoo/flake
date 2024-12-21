{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./default.nix ];

  seth = {
    enable = true;
    standalone.enable = true;
  };

  nix = lib.mkIf config.seth.standalone.enable { package = pkgs.nix; };
}
