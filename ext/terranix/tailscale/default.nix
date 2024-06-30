{ lib, ... }:
{
  imports = [
    ./acl.nix
    ./devices.nix
    ./dns.nix
    ./tags.nix
  ];

  provider.tailscale = {
    tailnet = lib.tfRef "var.tailnet";
  };
}
