{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../shared
    ./documentation.nix
    ./networking.nix
    ./nix.nix
    ./programs.nix
    ./security.nix
  ];

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
}
