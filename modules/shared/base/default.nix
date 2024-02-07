{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.base;
  inherit (inputs) self;
in {
  options.base = {
    enable = lib.mkEnableOption "basic configurations";
  };

  imports = [
    ./documentation.nix
    ./nix.nix
    ./programs.nix
  ];

  config = lib.mkIf cfg.enable {
    system.configurationRevision = self.rev or self.dirtyRev or "dirty-unknown";
  };
}
