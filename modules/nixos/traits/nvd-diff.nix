{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.nvd-diff;
in
{
  options.traits.nvd-diff = {
    enable = lib.mkEnableOption "showing configuration diffs with NVD on upgrade" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
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
