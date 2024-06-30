{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.base;
in
{
  imports = [
    ../../shared
    ./networking.nix
    ./nix.nix
    ./programs.nix
    ./security.nix
    ./users.nix
  ];

  config = lib.mkIf cfg.enable {
    services.journald.extraConfig = ''
      MaxRetentionSec=1w
    '';

    system.activationScripts."upgrade-diff" = {
      supportsDryActivation = true;
      text = ''
        ${lib.getExe pkgs.nvd} \
          --nix-bin-dir=${config.nix.package}/bin \
          diff /run/current-system "$systemConfig"
      '';
    };
  };
}
