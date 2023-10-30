{lib, ...}: {
  imports = [./nix.nix];

  documentation.man.enable = lib.mkDefault true;
  time.timeZone = lib.mkDefault "America/New_York";

  programs.gnupg.agent.enable = lib.mkDefault true;
}
