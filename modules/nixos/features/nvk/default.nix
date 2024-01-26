{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.nvk;
  mesa = import ./mesa.nix pkgs;
  mesa32 = import ./mesa.nix pkgs.pkgsi686Linux;
in {
  options.features.nvk.enable = lib.mkEnableOption "nvk";

  config = lib.mkIf cfg.enable {
    # make sure we're loading new gsp firmware
    boot.kernelParams = [
      "nouveau.config=NvGspRm=1"
      "nouveau.debug=info,VBIOS=info,gsp=debug"
    ];

    environment.sessionVariables = {
      # (fake) advertise vk 1.3
      MESA_VK_VERSION_OVERRIDE = "1.3";
    };

    hardware.opengl = {
      package = mesa.drivers;
      package32 = mesa32.drivers;
    };

    system.replaceRuntimeDependencies = [
      {
        original = pkgs.mesa.out;
        replacement = mesa.out;
      }
      {
        original = pkgs.pkgsi686Linux.mesa.out;
        replacement = mesa32.out;
      }
    ];
  };
}
