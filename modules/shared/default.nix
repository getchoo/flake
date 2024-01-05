{lib, ...}: {
  imports = [./nix.nix];

  documentation = {
    doc.enable = false;
    info.enable = false;
  };

  time.timeZone = lib.mkDefault "America/New_York";

  programs.gnupg.agent.enable = lib.mkDefault true;
}
