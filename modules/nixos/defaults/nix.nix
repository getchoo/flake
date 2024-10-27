{ lib, ... }:
{
  nix = {
    channel.enable = lib.mkDefault false;
    settings.trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
