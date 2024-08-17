{ pkgs, inputs, ... }:
{
  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  archetypes.personal.enable = true;

  base = {
    # this conflicts with nixos-wsl
    networking.enable = false;
    security = {
      # something, something `resolv.conf` error
      # (nixos-wsl probably doesn't set it)
      apparmor = false;
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    wslu
  ];

  networking.hostName = "glados-wsl";

  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "23.11";

  traits.tailscale.enable = true;

  wsl = {
    enable = true;
    defaultUser = "seth";
    interop = {
      includePath = false; # this is so annoying
      register = true;
    };
  };
}
