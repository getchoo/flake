{
  config,
  pkgs,
  ...
}: {
  system.activationScripts."upgrade-diff" = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
    '';
  };
}
