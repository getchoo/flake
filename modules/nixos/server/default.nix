{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.server;
in
{
  options.server = {
    enable = lib.mkEnableOption "server settings";
  };

  imports = [
    ./host-user.nix
    ./mixins
  ];

  config = lib.mkIf cfg.enable {
    _module.args.unstable = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

    boot.tmp.cleanOnBoot = lib.mkDefault true;

    documentation.enable = false;

    environment.defaultPackages = lib.mkForce [ ];

    nix = {
      gc = {
        dates = "Mon,Wed,Fri *-*-* 00:00:00";
        options = "-d --delete-older-than 2d";
      };

      settings.allowed-users = [ config.networking.hostName ];
    };
  };
}
