{
  lib,
  inputs,
  ...
}: let
  inherit (inputs) self;
in {
  imports = [
    ./nix.nix
    ./suites
    ./users
  ];

  system.configurationRevision = self.rev or self.dirtyRev or "dirty-unknown";

  documentation = {
    doc.enable = false;
    info.enable = false;
  };

  time.timeZone = lib.mkDefault "America/New_York";

  programs.gnupg.agent.enable = lib.mkDefault true;
}
